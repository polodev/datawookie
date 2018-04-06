---
author: Andrew B. Collier
date: 2017-08-31T11:00:00Z
tags: ["AWS"]
title: Driving AWS from the Command Line
---

Although it's very handy (and easy) to set up some cloud resources using the AWS Management Console, once you know what you need it makes a lot of sense to automate the process. Fortunately there's a handy little command line tools, `aws`, which makes this eminently possible. The [AWS CLI Command Reference](http://docs.aws.amazon.com/cli/latest/index.html) is the definitive resource for this tool. There's a mind boggling array of possibilities. We'll take a look at a small selection of them.

<!--more-->

<!-- https://cloudranger.com/how-to-configure-the-aws-cli-and-launch-an-ec2-instance/ -->
<!-- http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/Welcome.html -->
<!-- http://docs.aws.amazon.com/cli/latest/userguide/tutorial-ec2-ubuntu.html -->

## Install

The `aws` tool is a Python script. Installation is very simple, just follow the [detailed documentation](http://docs.aws.amazon.com/cli/latest/userguide/installing.html).

## Configure

Specify your AWS Access Key ID and Secret Access Key.

{{< highlight bash >}}
$ aws configure
{{< /highlight >}}

## SSH Key

You'll need a SSH key to connect to your remote resources.

{{< highlight bash >}}
$ aws ec2 create-key-pair --key-name datawookie-sydney | jq -r .KeyMaterial >~/.ssh/datawookie-sydney.pem
{{< /highlight >}}

The result from `aws ec2 create-key-pair` is a JSON document, from which we extract the value for `KeyMaterial` using the command-line JSON processor `jq`.

Apply restrictive access permissions to the resulting PEM file.

{{< highlight bash >}}
$ chmod 0400 ~/.ssh/datawookie-sydney.pem
{{< /highlight >}}

## Security Group

Create a Security Group. This will be used to determine what services will have access to your resources.

{{< highlight bash >}}
$ aws ec2 create-security-group --group-name general --description "SSH / HTTP / HTTPS"
{
    "GroupId": "sg-933cf8f5"
}
{{< /highlight >}}

Add some rules for inbound connections. Here we allow ports 22 (SSH), 80 (HTTP) and 443 (HTTPS).

{{< highlight bash >}}
$ aws ec2 authorize-security-group-ingress --group-name general --protocol tcp --port 22 --cidr 0.0.0.0/0
$ aws ec2 authorize-security-group-ingress --group-name general --protocol tcp --port 80 --cidr 0.0.0.0/0
$ aws ec2 authorize-security-group-ingress --group-name general --protocol tcp --port 443 --cidr 0.0.0.0/0
{{< /highlight >}}

Then check if everything is configured as expected. In light of the volume and complexity of the output of this command you might find it expedient to simply use the AWS Management Console.

{{< highlight bash >}}
$ aws ec2 describe-security-groups
{{< /highlight >}}

## Environment Variables

Since we'll be running `aws` from the shell it'll make our lives easier if we first set up a few environment variables.

### Region

Specify the region in which the resources are going to be deployed.

{{< highlight bash >}}
$ export REGION="ap-southeast-2"
{{< /highlight >}}

### Keyfile

The name assigned to your SSH key.

{{< highlight bash >}}
$ export KEYNAME="datawookie-sydney"
{{< /highlight >}}

## Elastic Compute Cloud (EC2)

Launch an EC2 instance using `aws ec2 run-instances`. You can find an appropriate image ID in Step 1 of the EC2 Launch Instance wizard.

{{< highlight bash >}}
$ aws ec2 run-instances --image-id ami-e2021d81 \
                        --security-group-ids sg-933cf8f5 \
                        --count 1 \
                        --instance-type t2.micro \
                        --key-name $KEYNAME
{{< /highlight >}}

Provided that the above command executed without error, you should have a running EC2 instance. Check out the Instances tab on the AWS Management Console. You can now connect to the remote instance using SSH.

## Elastic Map Reduce (EMR)

There's a wide variety of clusters that can be deployed using EMR. We'll put together a small Spark cluster.

First we'll need to create two new Security Groups, `spark-master` and `spark-slave`, where

- `spark-master` has the same permissions as `general` but also allows inbound TCP connections on port 8001;
- `spark-slave` has no inbound permissions.

Then run the script below, which will create a cluster with four nodes (one master and three workers). The nodes are provisioned with Spark and a few other pertinent applications. A bootstrap script also sets up JupyterHub.

{{< highlight bash >}}
aws emr create-cluster \
  --name 'Spark Cluster' \
  --release-label emr-5.2.0 \
  --applications Name=Hadoop Name=Hive Name=Spark Name=Pig Name=Tez Name=Ganglia Name=Presto \
  --region $REGION \
  --ec2-attributes '{
    "KeyName": "'$KEYNAME'",
    "InstanceProfile": "EMR_EC2_DefaultRole",
    "EmrManagedMasterSecurityGroup": "sg-4a4f8b2c",
    "EmrManagedSlaveSecurityGroup": "sg-d4498db2"
  }' \
  --service-role EMR_DefaultRole \
  --instance-groups \
    InstanceGroupType=MASTER,InstanceCount=1,InstanceType=c3.4xlarge,Name=Master \
    InstanceGroupType=CORE,InstanceCount=3,InstanceType=c3.4xlarge,Name=Worker \
  --bootstrap-actions '[{
    "Path": "s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh",
    "Args": ["--toree","--ds-packages","--jupyterhub","--jupyterhub-port","8001","--password","jupyter"],
    "Name": "Jupyter Notebook"
  }]'
{{< /highlight >}}

The `--password` parameter sets up the JupyerHub password for the `hadoop` user.

There are a host of other parameters which can be passed to the bootstrap script. Of particular interest are:

- `--r` --- install a kernel for R;
- `--julia` --- install a kernel for Julia;
- `--ruby` --- install a kernel for Ruby;
- `--ml-packages` --- install Python Machine Learning and Deep Learning packages;
- `--python-packages` --- install arbitrary named Python packages;
- `--port` --- port for Jupyter notebook (defaults to 8888);
- `--password` --- password for Jupyter Notebook.

It might take a while to bring up the cluster. The bootstrap process appears to be somewhat time consuming. However, if you're patient then in good time (an hour or so!) you'll have a fully provisioned Spark cluster with JupyterHub running on it.

The JupyterHub interface will be available on port 8001 on the master node. Find out more about this setup [here](https://aws.amazon.com/blogs/big-data/running-jupyter-notebook-and-jupyterhub-on-amazon-emr/).

## Simple Storage Service (S3)

<!-- http://docs.aws.amazon.com/cli/latest/reference/s3/ -->

S3 provides storage space which can be readily accessed from other resources on AWS.

### Creating a S3 Bucket

Storage on S3 is divided into containers called "buckets". Creating a bucket is simple with `aws s3 mb`.

{{< highlight bash >}}
$ aws s3 mb s3://datawookie-bucket
{{< /highlight >}}

### Copying Files to a Bucket

Local files can be copied across to a S3 bucket using `aws s3 cp`. You can restrict access to a file using the `--grants` option.

{{< highlight bash >}}
$ aws s3 cp iris.csv s3://datawookie-bucket
upload: ./iris.csv to s3://datawookie-bucket/iris.csv
{{< /highlight >}}

The commands `aws s3 mv` and `aws s3 rm` are analogous to their UNIX equivalents, moving and deleting files on S3.

The command `aws s3 sync` is used to synchronise the contents of folders, either local or on S3.

### Listing Buckets and Their Contents

You can get a list of available buckets using `aws s3 ls`.

{{< highlight bash >}}
$ aws s3 ls
2017-09-01 13:22:58 datawookie-bucket
{{< /highlight >}}

If you provide the URL for a particular bucket then you can also see its contents.

{{< highlight bash >}}
$ aws s3 ls s3://datawookie-bucket
2017-09-01 13:29:07       3716 iris.csv
{{< /highlight >}}

### Destroying a S3 Bucket

When you're done with your bucket you can destroy it with `aws s3 rb`. The `--force` argument is required to delete a bucket which still contains files.

{{< highlight bash >}}
$ aws s3 rb s3://datawookie-bucket --force
{{< /highlight >}}

### S3 and Static Web Sites

You can use the `aws s3 website` command to turn the contents of a S3 bucket into a static web site.