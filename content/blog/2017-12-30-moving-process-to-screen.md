---
title: "Moving a Running Process to screen"
date: 2017-12-30T04:00:00+00:00
author: Andrew B. Collier
excerpt_separator: <!-- more -->
layout: post
tags:
  - Ubuntu
---

I am not sure how many times this has happened to me, but it's not infrequent. I'm working on a remote session and I start a long running job. Then some time later I want to disconnect from the session but realise that if I do then the job will be killed.

I should have started job in `screen` or `tmux`!

So, is it possible to transfer the running process to `screen`? (Or, equally, to `tmux`?) Well it turns out that it is using the `reptyr` utility. I discovered this thanks to a [LinkedIn post](https://www.linkedin.com/pulse/move-running-process-screen-bruce-werdschinski/) by Bruce Werdschinski. A slightly refinement of his process is documented below.

<!-- more -->

## Create a Long Running Job

For illustration purposes, let's kick off a long running job.

{% highlight text %}
$ tail -f /var/log/syslog
{% endhighlight %}

That should start logging text to the terminal.

## Find the Process ID

Now we need to find out the PID for that process.

1. Suspend the process using <kbd>Ctrl</kbd>-<kbd>z</kbd>.

{% highlight text %}
[1]+  Stopped                 tail -f /var/log/syslog
{% endhighlight %}

{:start="2"}
2. Find the PID using `jobs`.

{% highlight text %}
$ jobs -l
[1]+ 20562 Stopped                 tail -f /var/log/syslog
{% endhighlight %}

Right, so the PID is 20562.

## Transfer Process to screen

At this point we need to get around a small wrinkle, circumventing a minor security measure.

{:start="3"}
3. Enable `ptrace`.

{% highlight text %}
$ echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
{% endhighlight %}

{:start="4"}
4. Start a `screen` session.

{% highlight text %}
$ screen
{% endhighlight %}

{:start="5"}
5. Use `reptyr` to reparent the process.

{% highlight text %}
$ reptyr 20562
{% endhighlight %}

The suspended process will be resumed.

{:start="6"}
6. Disconnect from the `screen` session.
7. Disable `ptrace`.

{% highlight text %}
$ echo 1 | sudo tee /proc/sys/kernel/yama/ptrace_scope
{% endhighlight %}

Done!

You can update the `ptrace` settings permanently, but given that reparenting should not be a frequent process, this is probably not necessary.