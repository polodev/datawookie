---
draft: true
title: 'Running Applications with Wine on Ubuntu'
date: 2017-10-11T07:00:00+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - Ubuntu
---

## Install Wine

<script src="https://gist.github.com/DataWookie/0e0e9cfebef214502bf19d36a6ba21bb.js"></script>

If you are feeling adventurous you could install `winehq-devel` or `winehq-staging`.

## Installing Applications

### SketchUp

{{< comment >}}
https://appdb.winehq.org/objectManager.php?sClass=version&iId=34500
{{< /comment >}}

{% highlight bash %}
export WINEARCH=win64
winetricks corefonts vcrun2015
winetricks win7
{% endhighlight %}

Download [.NET Framework](https://www.microsoft.com/en-us/download/details.aspx?id=42642).

{% highlight bash %}
wine start /unix NDP452-KB2901907-x86-x64-AllOS-ENU.exe
{% endhighlight %}

Download SketchUp [here](http://www.sketchup.com/download/all).

{% highlight bash %}
wine SketchUpMake-en-x64.exe
{% endhighlight %}