---
author: Andrew B. Collier
categories:
- Data Science
- Tableau
date: 2015-03-13T10:23:09Z
excerpt_separator: <!-- more -->
id: 1202
tags:
- locale
- Tableau
title: 'First Steps with Tableau: Decimal Separator'
url: /2015/03/13/first-steps-with-tableau-decimal-separator/
---

I downloaded a trial version of Tableau today and tried it out on one of the data sets I am currently working with. The data are stored in XLSX. Both the spreadsheet and my locale have a period set as the decimal separator, yet when I imported the data into Tableau it used a comma as the decimal separator.

<!--more-->

This confused me.

Fortunately there is an easy fix. From the Worksheet view, select File then Workbook Locale. Neither the Automatic not the English (South Africa) gave me the correct results. But selecting English (United Kingdom) sorted the problem.

<img src="{{ site.baseurl }}/static/img/2015/03/tableau-menu-locale.png">
