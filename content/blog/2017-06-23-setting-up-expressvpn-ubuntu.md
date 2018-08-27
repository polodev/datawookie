---
author: Andrew B. Collier
date: 2017-06-23T07:00:00Z
tags: ["Linux"]
title: Setting up ExpressVPN on Ubuntu
---

![](/img/2017/06/expressvpn-logo.jpg)

I've been meaning to set up a VPN and this morning seemed like a good time to tick it off the bucket list. This is a quick outline of my experience, which included one minor hiccup.

<!--more-->

## Sign Up

There are a number of vendors to choose from, but based on a recommendation I had a look at [ExpressVPN](https://www.expressvpn.com/). The first thing that you need to do is create an account. You'll need to provide credit card details and you have a choice of subscription periods. There's a 30 day money back offer, which means that you can try this out with no significant risk.

## Download the Client

Click the button to download the client. Then install.

{{< highlight bash >}}
$ ls -l *.deb
-rw-rw-r-- 1 colliera colliera 13440578 Jun 29 05:49 expressvpn_1.4.3_amd64.deb
$ sudo dpkg -i expressvpn_1.4.3_amd64.deb
{{< /highlight >}}

The install went flawlessly for me.

## Activation

Next you need to apply the activation code from the web site.

{{< highlight bash >}}
$ expressvpn activate
Enter activation code: 

Activated.
{{< /highlight >}}

## Connecting (First Attempt)

At this point everything had gone very smoothly and I was feeling most optimistic. So I went ahead and tried to connect to a VPN server. By default a connection will be made to a suitable server based on your geographic location.

{{< highlight bash >}}
$ expressvpn connect
Connecting to Smart Location...
Connecting to UK - Berkshire...	87.5%
We were unable to connect to this VPN location.

To connect, please try the following:

   - Check that your Internet connection is working and try to connect again.
   - Try connect to another VPN location.
   - Switch to another protocol
{{< /highlight >}}

Well, that's no good! Luckily it's easy to get some diagnostics.

{{< highlight bash >}}
$ expressvpn diagnostics | tail
Sat Jun 24 07:19:37 2017 OPTIONS IMPORT: route options modified
Sat Jun 24 07:19:37 2017 OPTIONS IMPORT: --ip-win32 and/or --dhcp-option options modified
Sat Jun 24 07:19:37 2017 TUN/TAP device tun0 opened
Sat Jun 24 07:19:37 2017 TUN/TAP TX queue length set to 100
Sat Jun 24 07:19:37 2017 do_ifconfig, tt->ipv6=0, tt->did_ifconfig_ipv6_setup=0
Sat Jun 24 07:19:37 2017 /sbin/ifconfig tun0 10.107.47.42 pointopoint 10.107.47.41 mtu 1500
Sat Jun 24 07:19:37 2017 Linux ifconfig failed: could not execute external program
Sat Jun 24 07:19:37 2017 Exiting due to fatal error
Disconnected with error: vpn process terminated unexpectedly
{{< /highlight >}}

That's unexpected: unable to execute `ifconfig`. I'm working on a fresh Ubuntu install, so evidently I haven't yet installed all of the usual tools. Easily remedied.

{{< highlight bash >}}
$ sudo apt install net-tools
{{< /highlight >}}

## Connecting (Second Attempt)

Let's try connecting again.

{{< highlight bash >}}
$ expressvpn connect
Connecting to Smart Location...
Connecting to UK - Berkshire...	100.0%

Connected.
{{< /highlight >}}

Bingo! Check your [IP address location](https://www.expressvpn.com/what-is-my-ip).

![](/img/2017/06/expressvpn-ip-berkshire.png)

So I've automatically been connected to a VPN server in Berkshire. Let's disconnect and see what other server locations are available.

{{< highlight bash >}}
$ expressvpn disconnect
$ expressvpn list | head
ALIAS	COUNTRY					LOCATION			RECOMMENDED
-----	---------------				------------------------------	-----------
smart	Smart Location				UK - Berkshire			Y
ukbe	United Kingdom (GB)			UK - Berkshire			Y
ukel						UK - East London		Y
uklo						UK - London
ukke						UK - Kent
ukbe2						UK - Berkshire - 2
ukch						UK - Chessington
ukma						UK - Maidenhead
$ expressvpn list | tail
ge1	Georgia (GE)				Georgia
az1	Azerbaijan (AZ)				Azerbaijan
kg1	Kyrgyzstan (KG)				Kyrgyzstan
eg1	Egypt (EG)				Egypt
ke1	Kenya (KE)				Kenya
dz1	Algeria (DZ)				Algeria
uz1	Uzbekistan (UZ)				Uzbekistan
bd1	Bangladesh (BD)				Bangladesh
bt1	Bhutan (BT)				Bhutan
bnbr	Brunei Darussalam (BN)			Brunei
$ expressvpn list | grep Africa
za1	South Africa (ZA)			South Africa			Y
{{< /highlight >}}

So there's a server located in South Africa. It's interesting to browse the full list of locations with ExpressVPN servers. Obviously the choice of server will be dictated by your reason for using the VPN. There's a handy [guide](https://www.expressvpn.com/support/troubleshooting/server-locations/) to the various considerations in choosing a server location.

We'll connect to the South African server by specifying its alias.

{{< highlight bash >}}
$ expressvpn connect za1
Connecting to South Africa...	100.0%

Connected.
{{< /highlight >}}

![](/img/2017/06/expressvpn-ip-pretoria.png)

I feel like I've just started to scratch the surface with this technology, but it's been a pleasant experience so far. Looking forward to delving deeper.

Some alternatives to ExpressVPN:

- [NordVPN](https://nordvpn.com/) (uses OpenVPN) 
