---
author: Andrew B. Collier
date: 2013-08-08T03:33:28Z
title: Finding Your MetaTrader Log Files
---

Debugging an indicator or expert advisor (EA) can be a tricky business. Especially when you are doing the debugging remotely. So I write my MQL code to include copious amounts of debugging information to log files. The contents of these log files can be used to diagnose any problems. This articles tells you where you can find those files.

<img src="/img/2013/08/metatrader-folder-structure.png" >

# Testing Logs

When you are running an EA under the strategy tester, the log files are written to the tester\logs directory (see the red rectangle in the directory tree above). The log files are named using the current date. For example, a file written on 8 August 2013 would be called 20130808.log. New information is simply appended to the end of the logs, so if you run the EA multiple times, then you will have information for all of those runs in a single log file.

# Trading Logs

When you are running an EA live, it writes logging information to files under the experts\logs directory (see the blue rectangle in the directory tree above). The same rules apply.

# Archived Logs

Log files are only retained for the last few days in each of the above directories. However, a full history of log files is retained in the top level logs directory (highlighted in grey in the directory tree above).

# Compression

The log files can get pretty big, so it is an idea to compress them before attaching them to an email.
