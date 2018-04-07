---
author: Andrew B. Collier
date: 2017-08-10T03:00:00Z
tags: ["AWS"]
title: Adding a Volume to an Ubuntu EC2 Instance
---

Some quick notes on adding a storage volume to an EC2 instance.

<!--more-->

<!-- http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-attaching-volume.html -->
<!-- http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/add-instance-store-volumes.html -->
<!-- http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html -->

A short while ago I put together a `m4.2xlarge` EC2 instance. My initial thoughts were that the CPU (8 virtual CPUs), RAM (32 GiB) and storage space (16 GiB) would be more than enough for my requirements. I was correct about the first two, but ran out of storage pretty quickly. I had two options: rebuild from scratch with more storage space or simply add another volume. In light of all the provisioning that I'd done, the latter option was definitely more appealing.

## Adding a New Volume

1. In the EC2 Management Console click on Volumes in menu at left.
2. Press the <kbd class="bg-primary">Create Volume</kbd> button.
3. Choose the size of the volume and the Availability Zone. The latter must be the same as that of the EC2 instance to which the volume will be attached.

![](/img/2017/08/aws-ec2-create-volume.png)

4. Press the <kbd class="bg-primary">Create</kbd> button.
5. After a short delay the new volume will appear in the list of available volumes. (I have found that I occasionally need to refesh the page to get the new volume to show up!)
6. Select the newly created volume and press the <kbd>Actions</kbd> button. Choose Attach Volume.
7. Click the Instance field. It should present you with a list of running instances, from which you can select the appropriate option. If not, manually fill in the ID of the EC2 instance you want. Also specify a location in `/dev/` where you want it to appear (something in the range `/dev/sdf` to `/dev/sdp` should work), although this will probably be filled with a default value, which is perfectly good!

## Mounting the New Volume

1. Connect to the EC2 instance using SSH.
2. Check for the new volume. Note that it will probably have have a different device name from what you specified above.

{{< highlight bash >}}
sudo lsblk
{{< /highlight >}}

Suppose that the new volume shows up at `/dev/xvdf`.

What you do next depends on how you want to use the partition.

### Swap Partition

First set up a swap area on the new partition.

{{< highlight bash >}}
sudo mkswap /dev/xvdf
{{< /highlight >}}

Then enable the partition for swapping.

{{< highlight bash >}}
sudo swapon /dev/xvdf
{{< /highlight >}}

### File Partition

Create a file system on the raw device.

{{< highlight bash >}}
sudo mkfs -t ext4 /dev/xvdf
{{< /highlight >}}

Go ahead and mount `/dev/xvdf` at a suitable location in your file hierarchy.