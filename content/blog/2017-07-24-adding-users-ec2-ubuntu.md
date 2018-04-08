---
author: Andrew B. Collier
date: 2017-07-24T01:00:00Z
tags: ["AWS", "Linux", "SSH"]
title: Adding Users to an EC2 Ubuntu Instance
---

By default an EC2 instance has only a single user other than `root`. For example, on a Ubuntu instance, that user is `ubuntu`. If there will be multiple people accessing the instance then it's generally necessary for each of them to have their own account. Setting this up is pretty simple, it just requires sorting out some authentication details.

<!--more-->

![](/img/logo/aws-logo.png)

## Creating User Accounts

First connect to the EC2 host. Authenticate with the PEM file that you downloaded when you created the instance. Obtain the URL from the AWS Management Console (in this case it's `ec2-34-229-87-235.compute-1.amazonaws.com`).

{{< highlight bash >}}
ssh -i ec2-ubuntu.pem ubuntu@ec2-34-229-87-235.compute-1.amazonaws.com
{{< /highlight >}}

Suppose that we are creating a new user account for Harold. Add the account.

{{< highlight bash >}}
sudo useradd harold -m -s /bin/bash
{{< /highlight >}}

That will create a home folder at `/home/harold/` and set the account's login shell to BASH.

## Sorting Out Authentication Keys

You've got (at least) two options for providing authentication credentials for the new user.

### Using Existing Public Key

If Harold uses SSH then he will already have both a private and a public key. Ask him to send you a copy of his public key (`~/.ssh/id_rsa.pub`). He should have no qualms about doing this since it is his *public* key.

### Creating a PEM File

If Harold is not already a SSH user then you can create a key pair from the EC2 Dashboard. Select "Key Pairs" from the menu on the left and then click the "Create Key Pair" button. A PEM file will be created and download automatically. Next you'll need to

1. Extract the corresponding public key from the PEM file.
{{< highlight bash >}}
chmod 0600 ec2-harold.pem 
ssh-keygen -y -f ec2-harold.pem
{{< /highlight >}}
{:start="2"}
2. Pass the PEM file (securely) on to Harold. Tell him not to lose it or share it!

## Logging In

In Harold's newly created home folder create a `.ssh` folder which will hold his public key.

{{< highlight bash >}}
sudo mkdir --mode 0700 /home/harold/.ssh
{{< /highlight >}}

Create a `authorized_keys` and copy the public key obtained above.

{{< highlight bash >}}
sudo vim /home/harold/.ssh/authorized_keys
{{< /highlight >}}

The contents of that file should look something like this:

{{< highlight text >}}
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCBNna+bXkl/gTkvkDbqiS5W3X5FBi6sYBl9iPSrhyHuSRgXJdTN9M64Z0OTxpAQIO+MYR6Y0P2SZGVqyaDrogL5djW9nm2+0gLoN4wUhg01wvJWAB5+7weAFyPHUcJQJ+kp9XPKrf2/eDay+DL7OeasLgJtzZ58Sedd/R7PRUSfqD4x4ff1KKgq0bs4IfmUp7kCHG72yy7tFC/+Rsd92eMSd98TvloJSWnb18CtrpCdtuY9M8kx6qLwiNkTIr/hUXbm98R/lhtNp4io4IhhW/v6hctqkKIamQ2TZuBZP9CnQ6FpIiwgSJfXfMHrtU0jA8vH02sC3lVjo2PdMIqJDbJ
{{< /highlight >}}

Finally sort out ownerships.

{{< highlight bash >}}
sudo chown -R harold.harold /home/harold/.ssh/
{{< /highlight >}}

## Setting the Authorised Key

Harold should now be able to login to the EC2 host. Depending on whether or not he needed a PEM file he would connect using either

{{< highlight bash >}}
ssh -i ~/Downloads/ec2-harold.pem harold@ec2-34-229-87-235.compute-1.amazonaws.com
{{< /highlight >}}

or simply

{{< highlight bash >}}
ssh harold@ec2-34-229-87-235.compute-1.amazonaws.com
{{< /highlight >}}