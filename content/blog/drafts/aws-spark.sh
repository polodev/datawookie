# https://aws.amazon.com/blogs/big-data/running-jupyter-notebook-and-jupyterhub-on-amazon-emr/

# The argument to --region must be where the SSH key lives!

# REGION="ap-southeast-2"
# KEYNAME="~/datawookie-sydney"

# aws emr create-cluster 
#   --ec2-attributes \
#     KeyName=$KEYNAME,\
#     InstanceProfile=EMR_EC2_DefaultRole \
#   --service-role EMR_DefaultRole \
#   --region $REGION \
#   --bootstrap-actions \
#     Name='Install Jupyter notebook',\
#     Path="s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh",\
#     Args=[--r,--julia,--toree,--torch,--ruby,--ds-packages,--ml-packages,--python-packages,'ggplot nilearn',--port,8880,--password,jupyter,--jupyterhub,--jupyterhub-port,8001,--cached-install,--copy-samples]

# aws emr create-cluster \
#   --name 'EMR Cluster' \
#   --password--applications Name=Hadoop Name=Hive Name=Spark Name=Pig Name=Tez Name=Ganglia Name=Presto \
#   --bootstrap-actions '[{ \
#       "Path":"s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh", \
#       "Args":["--r","--julia","--toree","--torch","--ruby","--ds-packages","--ml-packages","--python-packages","ggplot nilearn","--port","8880","--password","jupyter","--jupyterhub","--jupyterhub-port","8001","--cached-install","--copy-samples"], \
#       "Name":"Install Jupyter notebook"}]' \
#   --ec2-attributes '{ \
#       "KeyName":"datawookie-sydney", \
#       "InstanceProfile":"EMR_EC2_DefaultRole", \
#       "AvailabilityZone":"ap-southeast-2a", \
#       "EmrManagedSlaveSecurityGroup":"sg-467c8020", \
#       "EmrManagedMasterSecurityGroup":"sg-3702fe51"}' \
#   --service-role EMR_DefaultRole \
#   --release-label emr-5.2.0 \
#   --instance-groups '[{ \
#       "InstanceCount":1, \
#       "InstanceGroupType":"MASTER", \
#       "InstanceType":"c3.4xlarge", \
#       "Name":"MASTER" \
#     },{ \
#       "InstanceCount":4, \
#       "InstanceGroupType":"CORE", \
#       "InstanceType":"c3.4xlarge", \
#       "Name":"CORE"}]' \
#   --scale-down-behavior TERMINATE_AT_INSTANCE_HOUR \
#   --region ap-southeast-2


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
    "Path":"s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh",
    "Args":["--toree","--ds-packages","--jupyterhub","--jupyterhub-port","8001","--password","jupyter"],
    "Name":"Jupyter Notebook"
  }]'

    # "Args":["--toree","--ds-packages","--port","8880","--password","jupyter","--jupyterhub","--jupyterhub-port","8001"],

  # --bootstrap-actions '[{ \
  #     "Path":"s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh", \
  #     "Args":["--r","--julia","--toree","--torch","--ruby","--ds-packages","--ml-packages","--python-packages","ggplot nilearn","--port","8880","--password","jupyter","--jupyterhub","--jupyterhub-port","8001","--cached-install","--copy-samples"], \
  #     "Name":"Install Jupyter notebook"}]'

#    aws emr create-cluster --release-label emr-5.2.1 --name 'emr-5.2.1 sparklyr + jupyter cli example' \
# --applications Name=Hadoop Name=Hive Name=Spark Name=Pig Name=Tez Name=Ganglia Name=Presto \
# --ec2-attributes KeyName=mypemfilen,InstanceProfile=EMR_EC2_DefaultRole --service-role EMR_DefaultRole \
# --instance-groups InstanceGroupType=MASTER,InstanceCount=1,InstanceType=m3.xlarge \
# InstanceGroupType=CORE,InstanceCount=1,InstanceType=m3.xlarge \
# --region us-west-2 --log-uri s3://sparktesting1/ 
# --bootstrap-actions Name='Install Jupyter notebook',Path="s3://aws-bigdata-blog/artifacts/aws-blog-emr-jupyter/install-jupyter-emr5.sh",\
# Args=[--r,--toree,--ds-packages,--ml-packages,--python-packages,'pandas ggplot nilearn',\
# --port,8880,--password,mjupyter,--jupyterhub,--jupyterhub-port,8001,--cached-install,\
# --notebook-dir,s3://sparktesting1/notebook/,--copy-samples,--s3fs]

# aws emr describe-cluster --cluster-id j-XXXXXXXX

# aws emr list-clusters --active