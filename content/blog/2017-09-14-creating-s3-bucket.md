---
author: Andrew B. Collier
date: 2017-09-14T05:00:00Z
tags: ["AWS"]
title: Creating a S3 Bucket
---

There are many good reasons to use S3 (Simple Storage Service) storage. This is a quick overview of how to create a S3 bucket.

<!--more-->

## Creating the S3 Bucket

To create a S3 bucket go to the S3 Management Console. Press the <kbd class="bg-primary nobreak">Create bucket</kbd> button.

![](/img/2017/09/aws-s3-management-console.png)

Choose a name for the bucket and select a region. If you have existing EC2 instances then it makes sense to select the same location. Press the <kbd class="bg-primary nobreak">Next</kbd> button.

![](/img/2017/09/aws-s3-name.png)

You can choose to apply Versioning, Logging or Tags to the bucket. But for the moment we'll just skip over those and press the <kbd class="bg-primary nobreak">Next</kbd> button.

![](/img/2017/09/aws-s3-properties.png)

You can also have rather fine grained control over access permissions. But, again, we'll accept the defaults and simply press the <kbd class="bg-primary nobreak">Next</kbd> button.

![](/img/2017/09/aws-s3-permissions.png)

Finally review your choices and if everything is at it should be then press the <kbd class="bg-primary nobreak">Create bucket</kbd> button.

![](/img/2017/09/aws-s3-review.png)

The newly created bucket should then appear on your bucket list (this is the *other* type of bucket list!).

You can also create the bucket using the [AWS CLI interface]({{< relref "2017-08-31-using-aws-cli.md" >}}).