---
author: Andrew B. Collier
date: 2015-03-13T10:23:09Z
tags: ["Tableau"]
title: 'First Steps with Tableau: Decimal Separator'
---

I downloaded a trial version of Tableau today and tried it out on one of the data sets I am currently working with. The data are stored in XLSX. Both the spreadsheet and my locale have a period set as the decimal separator, yet when I imported the data into Tableau it used a comma as the decimal separator.

<!--more-->

This confused me.

Fortunately there is an easy fix. From the Worksheet view, select File then Workbook Locale. Neither the Automatic not the English (South Africa) gave me the correct results. But selecting English (United Kingdom) sorted the problem.

<img src="/img/2015/03/tableau-menu-locale.png">
