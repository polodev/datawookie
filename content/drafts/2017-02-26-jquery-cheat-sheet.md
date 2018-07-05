---
draft: true
title: jQuery Cheat Sheet
author: andrew
type: post
date: 2017-02-26T08:21:24+00:00
categories:
  - JavaScript
  - jQuery
tags:
  - jQuery

---

https://www.digitalocean.com/community/tutorials/an-introduction-to-jquery

## Class Operations

`.addClass()` and `.removeClass()`

## Manipulating CSS

[code language=&#8221;JavaScript&#8221; gutter=&#8221;false&#8221;]
  
$("#target").css("color", "green");
  


## Manipulating Properties

[code language=&#8221;JavaScript&#8221; gutter=&#8221;false&#8221;]
  
$("#target").prop("disabled", "true");
  


## Adding and Removing Content

You can use `.html()` to add text content and tags, while `.text()` is just for adding text content. Both of these will replace any existing content.

[code language=&#8221;JavaScript&#8221; gutter=&#8221;false&#8221;]
  
$("#target").html("<em>Some emphasised text.</em>");
  
$("h1").html("Page Title");
  


Excising content is done with `.remove()`.

[code language=&#8221;JavaScript&#8221; gutter=&#8221;false&#8221;]
  
$("#target").remove();
  


## Moving Stuff Around

Use `.appendTo()` to move the selected element to the end of another element.

If, rather than moving an element, you want to copy an element to a new location then use the combination `.clone().appendTo()`.

## Selecting Related Elements

With `.parent()` you can select the immediately enclosing element. Similarly you can target enclosed elements with `.children()`.
