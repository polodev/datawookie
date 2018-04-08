---
author: Andrew B. Collier
date: 2017-09-21T08:30:00Z
tags: ["Linux", "AWS"]
title: Diagnosing Killed Jobs on EC2
---

I've got a long running optimisation problem on a EC2 instance. Yesterday it was mysteriously killed. I shrugged it off as an anomaly and restarted the job. However, this morning it was killed again. Definitely not a coincidence! So I investigated. This is what I found and how I am resolving the problem.

<!--more-->

I had the job running on a `c4.2xlarge` instance with 8 vCPUs and 15 GiB of RAM. I'd also added 4 GiB of swap space. Seemed to be perfectly adequate.

## Understanding the Problem

The jobs died with a curt and rather uninformative message in the console:

{{< highlight bash >}}
Killed
{{< /highlight >}}

Hard to figure out the source of the problem. Luckily Ubuntu comes with a plethora of tools for debugging. I had a look at the output from `dmesg` and that immediately pointed me to the source of the problem.

The `dmesg` output is included below. I've edited out some of the irrelevant details.

{{< highlight text >}}
[84123.043569] R invoked oom-killer: gfp_mask=0x24280ca, order=0, oom_score_adj=0
[84123.043572] R cpuset=/ mems_allowed=0
[84123.043577] CPU: 1 PID: 3026 Comm: R Not tainted 4.4.0-1013-aws #22-Ubuntu
[84123.043578] Hardware name: Xen HVM domU, BIOS 4.2.amazon 08/24/2006
[84123.043579]  0000000000000286 00000000dc1b66b5 ffff8803bce03af8 ffffffff813f72a3
[84123.043582]  ffff8803bce03cb0 ffff8803bc55ee00 ffff8803bce03b68 ffffffff8120a22a
[84123.043583]  ffffffff81ccfa59 0000000000000000 ffffffff81e66820 0000000000000206
[84123.043585] Call Trace:
[84123.043590]  [<ffffffff813f72a3>] dump_stack+0x63/0x90
[84123.043594]  [<ffffffff8120a22a>] dump_header+0x5a/0x1c5
[84123.043597]  [<ffffffff81191de2>] oom_kill_process+0x202/0x3c0
[84123.043598]  [<ffffffff81192209>] out_of_memory+0x219/0x460
[84123.043600]  [<ffffffff811981f8>] __alloc_pages_slowpath.constprop.88+0x938/0xad0
[84123.043602]  [<ffffffff81198616>] __alloc_pages_nodemask+0x286/0x2a0
[84123.043605]  [<ffffffff811e38dd>] alloc_pages_vma+0xad/0x250
[84123.043609]  [<ffffffff811c175e>] handle_mm_fault+0x148e/0x1820
[84123.043611]  [<ffffffff811ca564>] ? mprotect_fixup+0x154/0x240
[84123.043614]  [<ffffffff8106b517>] __do_page_fault+0x197/0x400
[84123.043616]  [<ffffffff8106b7a2>] do_page_fault+0x22/0x30
[84123.043618]  [<ffffffff81830ef8>] page_fault+0x28/0x30
[84123.043620] Mem-Info:
[84123.043623] active_anon:3360321 inactive_anon:415812 isolated_anon:0
                active_file:179 inactive_file:83 isolated_file:0
                unevictable:915 dirty:0 writeback:0 unstable:0
                slab_reclaimable:8631 slab_unreclaimable:7256
                mapped:815 shmem:293 pagetables:11188 bounce:0
                free:32567 free_pcp:0 free_cma:0
{{< /highlight >}}

That's the first sign that something is going horribly wrong: `R invoked oom-killer`. The [OOM Killer](https://linux-mm.org/OOM_Killer) is responsible for killing tasks when the system is running out of memory.

{{< highlight text >}}
[84123.043666] 15269 total pagecache pages
[84123.043667] 14216 pages in swap cache
[84123.043668] Swap cache stats: add 1550042, delete 1535826, find 198214/303678
[84123.043669] Free swap  = 0kB
[84123.043670] Total swap = 4194300kB
[84123.043671] 3932061 pages RAM
[84123.043671] 0 pages HighMem/MovableOnly
[84123.043672] 82279 pages reserved
[84123.043672] 0 pages cma reserved
[84123.043673] 0 pages hwpoisoned
{{< /highlight >}}

Some high level information on memory allocation. Note that all of the swap space has been used!

Then some details on memory allocation to individual processes.

{{< highlight text >}}
[84123.043674] [ pid ]   uid  tgid total_vm      rss nr_ptes nr_pmds swapents oom_score_adj name
[84123.043678] [  457]     0   457    10968      260      22       3     1081             0 systemd-journal
[84123.043680] [  492]     0   492    25742       44      17       3        2             0 lvmetad
[84123.043681] [ 1010]     0  1010     4030       53      11       3      163             0 dhclient
[84123.043682] [ 1146]   104  1146    65158       33      29       4      162             0 rsyslogd
[84123.043684] [ 1149]     0  1149     7155       36      18       3       44             0 systemd-logind
[84123.043685] [ 1152]     0  1152     1100       24       8       3        0             0 acpid
[84123.043686] [ 1166]     0  1166     6517       39      17       3       29             0 cron
[84123.043687] [ 1172]     0  1172    58693       60      17       3       13             0 lxcfs
[84123.043688] [ 1174]     0  1174    68235       92      37       3      600             0 accounts-daemon
[84123.043690] [ 1179]   107  1179    10752      100      26       3       51          -900 dbus-daemon
[84123.043691] [ 1236]     0  1236     6511       14      18       3       36             0 atd
[84123.043692] [ 1263]     0  1263     3344       19      10       3       18             0 mdadm
[84123.043693] [ 1267]     0  1267    69295       49      38       3      128             0 polkitd
[84123.043694] [ 1309]     0  1309     4902       39      15       3       46             0 irqbalance
[84123.043696] [ 1322]     0  1322     3211       17      13       3       18             0 agetty
[84123.043697] [ 1323]     0  1323     3665       18      12       3       18             0 agetty
[84123.043698] [32003]   100 32003    25082      357      21       3       51             0 systemd-timesyn
[84123.043700] [12393]     0 12393    10517      421      23       3       94         -1000 systemd-udevd
[84123.043701] [12574]   108 12574     6720       29      18       3       20             0 uuidd
[84123.043703] [13640]     0 13640     1307       15       8       3       15             0 iscsid
[84123.043704] [13641]     0 13641     1432      884       8       3        0           -17 iscsid
[84123.043705] [13805]     0 13805    16381      346      34       3      152         -1000 sshd
[84123.043707] [13949]     0 13949    72061      531      35       6     2116          -900 snapd
[84123.043708] [ 2962]  1000  2962    11313      324      25       3      205             0 systemd
[84123.043709] [ 2964]  1000  2964    52192        9      37       4      499             0 (sd-pam)
[84123.043711] [ 3014]  1000  3014     6539      394      17       3       91             0 screen
[84123.043712] [ 3015]  1000  3015     5306      445      15       3      424             0 bash
[84123.043713] [ 3026]  1000  3026  3539683  2148000    6851      17  1028165             0 R
[84123.043715] [ 3041]  1000  3041   279574   216106     511       3     1716             0 R
[84123.043716] [ 3050]  1000  3050   289262   226319     534       4     1800             0 R
[84123.043717] [ 3059]  1000  3059   293135   229683     540       4     1733             0 R
[84123.043718] [ 3068]  1000  3068   302669   239210     556       3     1715             0 R
[84123.043720] [ 3077]  1000  3077   306739   243239     563       4     1820             0 R
[84123.043721] [ 3086]  1000  3086   306174   242549     563       4     1874             0 R
[84123.043722] [ 3095]  1000  3095   281520   218083     518       4     1784             0 R
{{< /highlight >}}

Note the final eight lines, which correspond to my optimisation job (it's running in parallel with seven worker threads). The biggest memory hog is PID 3026, which is the R master task.

Then the final *coup de grâce*: killing PID 3026, which in turn took down the rest of the R tasks.

{{< highlight text >}}
[84123.043724] Out of memory: Kill process 3026 (R) score 649 or sacrifice child
[84123.046405] Killed process 3026 (R) total-vm:14158732kB, anon-rss:8590380kB, file-rss:1620kB
{{< /highlight >}}

## Fixing the Problem

Obviously memory is the issue here. I thought that the available RAM and swap were sufficient, but evidently I was mistaken. These are the options I'm exploring to solve the problem:

1. upgrade to a larger instance (the `m4.2xlarge` also has 8 vCPUs but 32 GiB of RAM, although it's a *General Purpose* rather than a *Compute Optimised* instance); or
2. add an EBS volume and create a wide swathe of swap space.

![](/img/2017/09/comic-oom-killer.png)