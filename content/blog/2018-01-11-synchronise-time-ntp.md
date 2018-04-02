---
author: Andrew B. Collier
date: 2018-01-11T04:30:00Z
excerpt_separator: <!-- more -->
tags: ["NTP"]
title: 'NTP: Synchronise Your Watches'
url: /2018/01/11/synchronise-time-ntp/
---

Just like an old fashioned grandfather clock, time time on your computer's clock can slowly drift. You can quickly verify the accuracy of your clock by comparing it to <https://time.is/>. It's not unusual for it to be anything from a few seconds to a couple of minutes out. For most purposes this is not a major issue, but there are some applications which are very time sensitive.

[NTP](http://www.ntp.org/) (Network Time Protocol) is a tool which will synchronise your computer's clock with a network of accurate time servers, ensuring that it's always accurate.

There's a lot to be said about NTP, but this is a quick guide to getting it up and running on an Ubuntu machine.

<!--more-->

## Install

There's a `ntp` package in the APT repository, so installation is simple.

{{< highlight bash >}}
sudo apt install ntp
{{< / highlight >}}

The `ntpd` will start running. It will communicate with the time servers and bring your clock in line with the correct time.

{{< highlight text >}}
$ ps -fC ntpd
UID        PID  PPID  C STIME TTY          TIME CMD
ntp       2436     1  0 Jan10 ?        00:00:05 /usr/sbin/ntpd -p /var/run/ntpd.pid -g -u 126:136
{{< / highlight >}}

## Configure

The configuration for NTP is found in `/etc/ntp.conf`. The default configuration will probably be perfectly sufficient. However, if you are an inveterate fiddler, then you might want to tweak some of the details.

The default configuration will point `ntpd` to a selection of generic servers run by the NTP Pool Project. These will redirect to a server geographically close to you.

{{< highlight text >}}
# Use servers from the NTP Pool Project.
#
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst

# Use the Ubuntu NTP server as a backup.
#
pool ntp.ubuntu.com
{{< / highlight >}}

You can find out about local servers by visiting the [NTP Pool Project](http://www.pool.ntp.org/en/) and selecting first your continent and then country.

![](/img/2018/01/pool-ntp-south-africa.png)

## Check

It will take a short while for `ntpd` to connect to some time servers. Once it has you'll be able to check the accuracy of your local clock using `ntptime`.

{{< highlight text >}}
$ ntptime
ntp_gettime() returns code 0 (OK)
  time de02a775.12feb4a8  Fri, Jan 12 2018  5:18:13.074, (.074199554),
  maximum error 454101 us, estimated error 706 us, TAI offset 0
ntp_adjtime() returns code 0 (OK)
  modes 0x0 (),
  offset -1477.986 us, frequency 6.632 ppm, interval 1 s,
  maximum error 454101 us, estimated error 706 us,
  status 0x2001 (PLL,NANO),
  time constant 10, precision 0.001 us, tolerance 500 ppm,
{{< / highlight >}}

Alternatively, head back to <https://time.is/> to confirm your clock's accuracy.

![](/img/2018/01/time-is.png)