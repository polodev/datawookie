---
draft: true
title: Configuring RStudio on a Remote Windows Server
author: andrew
type: post
date: 2017-02-26T08:23:33+00:00
categories:
  - R
  - Windows
tags:
  - R
  - Windows

---
Setting up RStudio on a local Linux machine borders on being a trivial procedure. It seems to work straight out of the box.

I needed to get RStudio working on a remote [Citrix][1] server. My initial concerns were allayed when the Citrix administrator got the RStudio installed and running in a couple of minutes. However, when I started a remote RStudio session through the Citrix portal on my browser, things were not too healthy: I was confronted by a flurry of errors, most of which were complaining about paths being either missing or inaccessible.

It turns out that there is a simple fix for this (although it&#8217;s one that I had to tinker with quite a bit to get it working!). You need to set up an .Renviron file in your home (Documents) folder. This serves the following purposes:

  * tells R where to put user-installed packages (and then where to find those packages later!); and 
      * what the defauly working directory is when no project is specified. </ul> 
        The file should contain at least the following entries:
        
        [code language=&#8221;R&#8221; gutter=&#8221;false&#8221;]
  
        \# Set up environment variables. These can be accessed from within R like this:
  
        #
  
        \# > Sys.getenv("HOME")
  
        #
  
        R\_LIBS\_USER="H:/myCitrixFiles/Documents/R/win-library/3.1"
  
        R_USER="H:/myCitrixFiles/Documents"
  

        
        It&#8217;s probable that the exact paths will vary from one setup to the next. However, one critical thing to note is that there are no trailing slashes on those paths.

 [1]: http://www.citrix.com/
