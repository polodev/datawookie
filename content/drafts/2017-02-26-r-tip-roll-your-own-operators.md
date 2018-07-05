---
draft: true
title: 'R Tip: Roll Your Own Operators'
author: andrew
type: post
date: 2017-02-26T08:22:26+00:00
categories:
  - R
  - R Tip
tags:
  - R

---
https://www.quora.com/What-are-some-good-hacks-at-using-R/answer/Yasmin-Lucero?srid=3iSc

\`%+%\` = paste0
  
will give you a more familiar feel when concatenating strings:
  
cat(&#8220;I have &#8221; %+% x %+% &#8221; apples.\n&#8221;)
