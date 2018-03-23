---
id: 1573
title: 'Excel: Copying with Relative Links'
date: 2015-06-26T12:25:51+00:00
author: Andrew B. Collier
layout: post
excerpt_separator: <!-- more -->
tags:
  - Excel
---

<!-- more -->

Copying a range of cells but keeping the targets for relative links? Doesn't quite work as you expected. Or hoped.

The greens cells below each contain a relative link to the "data" cell five places to the left.

<img src="{{ site.baseurl }}/static/img/2015/06/copy-rel-links-1.png">

If we simply Copy and Paste those green cells then we see that the relative links move as well. This is often what you want to happen. Often but not always. What about if you want the links in the copied cells to be preserved? None of the various Paste options offered in Excel will do this.

<img src="{{ site.baseurl }}/static/img/2015/06/copy-rel-links-2.png">

But there is a way around this problem. First Copy the range of cells in question and Paste to a temporary location. Next Cut the range of cells and Paste to the new location. The Cut and Paste action will not alter the relative links.

<img src="{{ site.baseurl }}/static/img/2015/06/copy-rel-links-3.png">

Finally Copy and Paste from the temporary location back to the original location. Delete the temporary copy.

<img src="{{ site.baseurl }}/static/img/2015/06/copy-rel-links-4.png">
