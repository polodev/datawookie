---
author: Andrew B. Collier
date: 2015-10-16T11:55:44Z
title: 'WordPress: Underscores and SyntaxHighlighter Evolved'
---

The underscores are invisible in the code that I'm displaying on WordPress using the SyntaxHighlighter Evolved. After a bit of research I found that this was due to the line height being set too small.

<!--more-->

Fortunately there's a quick fix: in `wp-content/plugins/syntaxhighlighter/syntaxhighlighter3/styles/shCore.css` just increase the value of `line-height`.

{{< highlight css >}}
.syntaxhighlighter textarea {
  -moz-border-radius: 0 0 0 0 !important;
  -webkit-border-radius: 0 0 0 0 !important;
  background: none !important;
  border: 0 !important;
  bottom: auto !important;
  float: none !important;
  height: auto !important;
  left: auto !important;
  line-height: 1.51em !important;
  margin: 0 !important;
  outline: 0 !important;
  overflow: visible !important;
  padding: 0 !important;
  position: static !important;
  right: auto !important;
  text-align: left !important;
  top: auto !important;
  vertical-align: baseline !important;
  width: auto !important;
  box-sizing: content-box !important;
  font-family: "Consolas", "Bitstream Vera Sans Mono", "Courier New", Courier, monospace !important;
  font-weight: normal !important;
  font-style: normal !important;
  font-size: 1em !important;
  /*min-height: inherit !important; */
  /*min-height: auto !important;*/
  direction: ltr !important;
  -webkit-box-shadow: none !important;
  -moz-box-shadow: none !important;
  -ms-box-shadow: none !important;
  -o-box-shadow: none !important;
  box-shadow: none !important;
}
{{< /highlight >}}
