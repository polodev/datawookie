---
author: Andrew B. Collier
date: 2017-08-20T05:00:00Z
tags: ["BASH"]
title: Setting Up Time Zones in BASH
---

Ensuring that your account is configured to run with appropriate time zone information can make your life a lot easier.

Of course, if you administer your own system then you can simply set your system time to local time. However, it's generally a better idea to set system time to Universal Time (UTC) and then configure time zone information on a per-user basis.

Why does this make sense? Well, suppose that you have remote users logging onto your system. It's very likely that a remote user will be operating in a different time zone and it'd be handy for them to have system time converted into their local time.

<!--more-->

There's a handy utility for putting this in place: `tzselect`. It presents a couple of simple menus and then delivers a small chunk of code that you'd include in a user's `.profile` file to ensure that their time zone is configured correctly.

Here's an example of selecting the time zone for South Africa.

{{< highlight text >}}
$ tzselect
Please identify a location so that time zone rules can be set correctly.
Please select a continent, ocean, "coord", or "TZ".
 1) Africa
 2) Americas
 3) Antarctica
 4) Asia
 5) Atlantic Ocean
 6) Australia
 7) Europe
 8) Indian Ocean
 9) Pacific Ocean
10) coord - I want to use geographical coordinates.
11) TZ - I want to specify the time zone using the Posix TZ format.
#? 1
Please select a country whose clocks agree with yours.
 1) Algeria               20) Gambia                39) Sao Tome & Principe
 2) Angola                21) Ghana                 40) Senegal
 3) Benin                 22) Guinea                41) Sierra Leone
 4) Botswana              23) Guinea-Bissau         42) Somalia
 5) Burkina Faso          24) Kenya                 43) South Africa
 6) Burundi               25) Lesotho               44) South Sudan
 7) Cameroon              26) Liberia               45) Spain
 8) Central African Rep.  27) Libya                 46) St Helena
 9) Chad                  28) Madagascar            47) Sudan
10) Comoros               29) Malawi                48) Swaziland
11) Congo (Dem. Rep.)     30) Mali                  49) Tanzania
12) Congo (Rep.)          31) Mauritania            50) Togo
13) Côte d'Ivoire         32) Mayotte               51) Tunisia
14) Djibouti              33) Morocco               52) Uganda
15) Egypt                 34) Mozambique            53) Western Sahara
16) Equatorial Guinea     35) Namibia               54) Zambia
17) Eritrea               36) Niger                 55) Zimbabwe
18) Ethiopia              37) Nigeria
19) Gabon                 38) Rwanda
#? 43

The following information has been given:

        South Africa

Therefore TZ='Africa/Johannesburg' will be used.
Local time is now:      Mon Aug 21 05:06:15 SAST 2017.
Universal Time is now:  Mon Aug 21 03:06:15 UTC 2017.
Is the above information OK?
1) Yes
2) No
#? 1

You can make this change permanent for yourself by appending the line
        TZ='Africa/Johannesburg'; export TZ
to the file '.profile' in your home directory; then log out and log in again.

Here is that TZ value again, this time on standard output so that you
can use the /usr/bin/tzselect command in shell scripts:
Africa/Johannesburg
{{< /highlight >}}

To configure my account with this time zone information, I'd simply add

{{< highlight bash >}}
TZ='Africa/Johannesburg'; export TZ
{{< /highlight >}}

to my `.profile` file. It would come into effect the next time I logged into the system.