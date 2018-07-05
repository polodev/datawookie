---
draft: true
title: SourceTree and GitLab
author: andrew
type: post
date: 2017-02-26T08:23:04+00:00
categories:
  - Version Control
tags:
  - Git
  - GitLab
  - SourceTree

---
In order to get SourceTree to work with my GitLab repositories I had to disable Git SSL verification using:
  
[code gutter=&#8221;false&#8221;]
  
git config &#8211;global http.sslVerify false
  

