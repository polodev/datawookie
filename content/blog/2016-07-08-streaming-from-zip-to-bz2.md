---
id: 3622
title: Streaming from zip to bz2
date: 2016-07-08T12:12:44+00:00
author: Andrew B. Collier
layout: post
guid: http://www.exegetic.biz/blog/?p=3622
categories:
  - Linux
tags:
  - bzip2
  - compression
  - funzip
  - Linux
---
I've got a massive bunch of zip archives, each of which contains only a single file. And the name of the enclosed file varies. Dealing with these data is painful.

It'd be a lot more convenient if the files were compressed with `gzip` or `bzip2` and had a consistent naming convention. How would you go about making that conversion without actually unpacking the zip archive, finding the name of the enclosed file and then recompressing? Enter `funzip`.

To illustrate, first we create a zip archive with a single file.

{% highlight bash %}
$ ls -l foo.txt
-rw-rw-r- 1 user user 2311 Jul 8 14:06 foo.txt
$ zip foo.zip foo.txt
  adding: foo.txt (deflated 62%)
$ ls -l foo.zip
-rw-rw-r- 1 user user 1031 Jul 8 14:06 foo.zip
{% endhighlight %}

Then extract the single file to standard output using `funzip` and pipe the results through `bzip2`.

{% highlight bash %}
$ funzip foo.zip | bzip2 >foo.bz2
$ ls -l foo.bz2
-rw-rw-r- 1 user user 924 Jul 8 14:06 foo.bz2
{% endhighlight %}

Another, more robust, approach is to simply use `unzip` with `-c` (extract to stdout) and `-qq` (be super quiet).

{% highlight bash %}
unzip -qq -c foo.zip | bzip2 >foo.bz2
{% endhighlight %}

Voila!
