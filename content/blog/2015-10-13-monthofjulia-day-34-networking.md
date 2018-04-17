---
author: Andrew B. Collier
date: 2015-10-13T15:00:25Z
tags: ["Julia"]
title: 'MonthOfJulia Day 34: Networking'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Networking.png" >

Today's post is a mashup of various things relating to networking with Julia. We'll have a look at FTP transfers, HTTP requests and using the Twitter API.

<blockquote>
Only wimps use tape backup: real men just upload their important stuff on ftp, and let the rest of the world mirror it.
<cite><a href="https://en.wikiquote.org/wiki/Linus_Torvalds">Linus Torvalds</a> (1996)</cite> 
</blockquote>

Back in the mid-90s Linus Torvalds was a big fan of FTP. I suspect that his sentiments have not changed, although now he'd probably modify that statement with `'s/upload/push/;s/ftp/github/'`. He might have made it more gender neutral too, but it's hard to be sure.

## FTP

FTP seems a little "old school", but if you grew up in the 1980s, before scp and sftp came along, then you'll probably feel (like me) that FTP is an intrinsic part of the internet experience. There are still a lot of anonymous FTP sites in operation. You can find a list [here](http://www.ftp-sites.org/), although it appears to have last been updated in 2003, so some of that information might no longer be valid. We'll use <ftp://speedtest.tele2.net/> for illustrative purposes since it also allows uploads.

First we initiate a connection to the FTP server.

{{< highlight julia >}}
julia> using FTPClient
julia> ftp_init();
julia> ftp = FTP(host = "speedtest.tele2.net", user = "anonymous", pswd = "hiya@gmail.com")
Host:      ftp://speedtest.tele2.net/
User:      anonymous
Transfer:  passive mode
Security:  None
{{< /highlight >}}

Grab a list of files available for download.

{{< highlight julia >}}
julia> readdir(ftp)
18-element Array{ByteString,1}:
 "1000GB.zip"
 "100GB.zip"
 "100KB.zip"
 "100MB.zip"
 "10GB.zip"
 "10MB.zip"
 "1GB.zip"
 "1KB.zip"
 "1MB.zip"
 "200MB.zip"
 "20MB.zip"
 "2MB.zip"
 "3MB.zip"
 "500MB.zip"
 "50MB.zip"
 "512KB.zip"
 "5MB.zip"
 "upload"
{{< /highlight >}}

This site (as its name would imply) has the sole purpose of conducting speed tests. So the content of those files is not too interesting. But that's not going to stop me from downloading one.

{{< highlight julia >}}
julia> binary(ftp) # Change transfer mode to BINARY
julia> download(ftp, "1KB.zip", "local-1KB.zip");
{{< /highlight >}}

Generally anonymous FTP sites do not allow uploads, but this site is an exception. We'll test that out too.

{{< highlight julia >}}
julia> cd(ftp, "upload")
julia> ascii(ftp) # Change transfer mode to ASCII
julia> upload(ftp, "papersize", open("/etc/papersize"));
{{< /highlight >}}

Close the connection when you're done.

{{< highlight julia >}}
julia> ftp_cleanup()
julia> close(ftp);
{{< /highlight >}}

Okay, I'm over the historical reminiscences now. Onto something more current.

## HTTP Clients

There are a few Julia packages implementing [HTTP methods](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods). We'll focus on the [Requests](https://github.com/JuliaWeb/Requests.jl) package. The package homepage makes use of <http://httpbin.org/> to illustrate the various bits of functionality. This is a good choice since it allows essentially all of the functionality in Requests to be exercised. We'll take a different approach and apply a subset of the functionality to a couple of more realistic scenarios. Specifically we'll look at the GET and POST requests.

First we'll use a GET request to retrieve information from [Google Books](https://books.google.com/) using ISBN to specify a particular book. The `get()` call below is equivalent to opening [this URL](https://www.googleapis.com/books/v1/volumes?q=isbn:178328479X) in your browser.

{{< highlight julia >}}
julia> r1 = get("https://www.googleapis.com/books/v1/volumes";
                query = {"q" => "isbn:178328479X"});
{{< /highlight >}}

We check that everything went well with the request: the status code of 200 indicates that it was successful. The request headers provide some additional metadata.

{{< highlight julia >}}
julia> r1.status
200
julia> r1.headers
Dict{AbstractString,AbstractString} with 18 entries:
  "Alt-Svc" => "quic=\":443\"; p=\"1\"; ma=604800"
  "Date" => "Mon, 12 Oct 2015 06:01:13 GMT"
  "http_minor" => "1"
  "Keep-Alive" => "1"
  "status_code" => "200"
  "Cache-Control" => "private, max-age=0, must-revalidate, no-transform"
  "Server" => "GSE"
  "Expires" => "Mon, 12 Oct 2015 06:01:13 GMT"
  "ETag" => "\"65-LEm5ATkHVhzLpHrk8rG7RWww/xI4TbmPbZwN2eJh_EyxSqn0UHDU\""
  "X-XSS-Protection" => "1; mode=block"
  "Content-Length" => "2092"
  "X-Content-Type-Options" => "nosniff"
  "Vary" => "X-Origin"
  "http_major" => "1"
  "Alternate-Protocol" => "443:quic,p=1"
  "Content-Type" => "application/json; charset=UTF-8"
  "X-Frame-Options" => "SAMEORIGIN"
  "Content-Language" => "en"
{{< /highlight >}}

The actual content is found in the JSON payload which is stored as an array of unsigned bytes in the `data` field. We can have a look at the text content of the payload using `Requests.text()`, but accessing fields in these data is done via `Requests.json()`. Finding the data you're actually looking for in the resulting data structure may take a bit of trial and error.

{{< highlight julia >}}
julia> typeof(r1.data)
Array{UInt8,1}
julia> Requests.json(r1)\["items"\]\[1\]["volumeInfo"] # Parsed JSON
Dict{AbstractString,Any} with 17 entries:
  "publisher" => "Packt Publishing"
  "industryIdentifiers" => Any[Dict{AbstractString,Any}("identifier"=>"178328479X","type"=>"ISBN_10"),Dict{AbstractString,Any}("identifier"=>"9781783…
  "language" => "en"
  "contentVersion" => "preview-1.0.0"
  "imageLinks" => Dict{AbstractString,Any}("smallThumbnail"=>"http://books.google.co.za/books/content?id=Rc0drgEACAAJ&printsec=frontcover&im…
  "readingModes" => Dict{AbstractString,Any}("image"=>false,"text"=>false)
  "printType" => "BOOK"
  "infoLink" => "http://books.google.co.za/books?id=Rc0drgEACAAJ&dq=isbn:178328479X&hl=&source=gbs_api"
  "previewLink" => "http://books.google.co.za/books?id=Rc0drgEACAAJ&dq=isbn:178328479X&hl=&cd=1&source=gbs_api"
  "allowAnonLogging" => false
  "publishedDate" => "2015-02-26"
  "canonicalVolumeLink" => "http://books.google.co.za/books/about/Getting_Started_with_Julia_Programming_L.html?hl=&id=Rc0drgEACAAJ"
  "title" => "Getting Started with Julia Programming Language"
  "categories" => Any["Computers"]
  "pageCount" => 214
  "authors" => Any["Ivo Balbaert"]
  "maturityRating" => "NOT_MATURE
{{< /highlight >}}

We see that the book in question was written by Ivo Balbaert and entitled "[Getting Started with Julia Programming Language](https://www.packtpub.com/application-development/getting-started-julia-programming)". It was published by Packt Publishing earlier this year. It's a pretty good book, well worth checking out.

If the payload is not JSON then we process the data differently. For example, after using `get()` to download CSV content from [Quandl](https://www.quandl.com/) you'd simply use `readtable()` from the DataFrames package to produce a data frame.

{{< highlight julia >}}
julia> URL = "https://www.quandl.com/api/v1/datasets/EPI/8.csv";
julia> using DataFrames
julia> population = readtable(IOBuffer(get(URL).data), separator = ',', header = true);
{{< /highlight >}}

{{< highlight julia >}}
julia> names!(population, [symbol(i) for i in ["Year", "Industrial", "Developing"]]);
julia> head(population)
6x3 DataFrames.DataFrame
| Row | Year         | Industrial | Developing |
|-----|--------------|------------|------------|
| 1   | "2100-01-01" | 1334.79    | 8790.14    |
| 2   | "2099-01-01" | 1333.72    | 8786.27    |
| 3   | "2098-01-01" | 1332.64    | 8782.08    |
| 4   | "2097-01-01" | 1331.54    | 8777.6     |
| 5   | "2096-01-01" | 1330.43    | 8772.83    |
| 6   | "2095-01-01" | 1329.32    | 8767.78    |
{{< /highlight >}}

Of course, as we saw on [Day 15](http://www.exegetic.biz/blog/2015/09/monthofjulia-day-15-time-series/), if you're going to access data from Quandl it would make more sense to use the [Quandl package](https://github.com/milktrader/Quandl.jl).

Those two queries above were submitted using GET. What about POST? We'll directly access the Twitter public API to see how many times the URL <http://julialang.org/> has been included in a tweet.

{{< highlight julia >}}
julia> r3 = post("http://urls.api.twitter.com/1/urls/count.json";
                 query = {"url" => "http://julialang.org/"}, data = "Quite a few times!");
julia> Requests.json(r3)
Dict{AbstractString,Any} with 2 entries:
  "count" => 2639
  "url" => "http://julialang.org/"
{{< /highlight >}}

The JSON payload has an element `count` which indicates that to date that URL has been included in 2639 distinct tweets.

We've just seen how to directly access the Twitter API using a POST request. We also know that there is a Quandl package which provides a wrapper around the Quandl API. Not too surprisingly there's also a wrapper for the Twitter API in the [Twitter package](https://github.com/randyzwitch/Twitter.jl). This package greatly simplifies interacting with the Twitter API. No doubt wrappers for other services will follow.

First you need to load the package and authenticate yourself. I've got my keys and secrets stored in environment variables which I retrieve using from the `ENV[]` global array.

{{< highlight julia >}}
julia> using Twitter
julia> consumer_key = ENV["CONSUMER_KEY"];
julia> consumer_secret = ENV["CONSUMER_SECRET"];
julia> oauth_token = ENV["OAUTH_TOKEN"];
julia> oauth_secret = ENV["OAUTH_SECRET"];
julia> twitterauth(consumer_key, consumer_secret, oauth_token, oauth_secret)
{{< /highlight >}}

I'll take this opportunity to pander to my own vanity, looking at which of my tweets have been retweeted. To make sense of the results, convert them to a `DataFrame`.

{{< highlight julia >}}
julia> retweets = DataFrame(get_retweets_of_me());
julia> retweets[:, [:created_at, :text]]
20x2 DataFrames.DataFrame
| Row | created_at                       | text                                                                                                              |
|-----|----------------------------------|-------------------------------------------------------------------------------------------------------------------|
| 1   | "Mon Oct 12 21:03:57 +0000 2015" | "Sparkline theory and practice Edward Tufte http://t.co/THgFkv3ZZS #Statistics @EdwardTufte"                      |
| 2   | "Mon Oct 12 18:33:49 +0000 2015" | "R Developer Fluent in Shiny and ggvis (\$100 for ~2 hours gig) http://t.co/sM8JRVOKiA #jobs"                     |
| 3   | "Mon Oct 12 15:31:39 +0000 2015" | "Installing LightTable and Juno on Ubuntu http://t.co/2sbEFR7MXR http://t.co/ZMmQ0QHEZs"                          |
| 4   | "Sun Oct 11 20:05:08 +0000 2015" | "On Forecast Intervals \"too Wide to be Useful\" http://t.co/pxqrpgkewu #Statistics"                              |
| 5   | "Sun Oct 11 20:04:01 +0000 2015" | "P-value madness: A puzzle about the latest test ban (or dont ask, dont tell) http://t.co/aBSgVYCb3E #Statistics" |
| 6   | "Sat Oct 10 19:04:37 +0000 2015" | "Seasonal adjusment on the fly with X-13ARIMA-SEATS, seasonal and ggplot2 http://t.co/hB9gW8LPn5 #rstats"         |
| 7   | "Sat Oct 10 14:34:04 +0000 2015" | "Doomed to fail: A pre-registration site for parapsychology http://t.co/NTEfpJim5k #Statistics"                   |
| 8   | "Sat Oct 10 13:34:41 +0000 2015" | "Doomed to fail: A pre-registration site for parapsychology http://t.co/7NwYJZRsky #Statistics"                   |
| 9   | "Sat Oct 10 08:34:43 +0000 2015" | "Too Much Information Can Ruin Your Presentation http://t.co/RdRp9V6EDd #Presentation #speaking"                  |
| 10  | "Fri Oct 09 20:03:32 +0000 2015" | "Manage The Surge In Unstructured Data http://t.co/fhqfNCNq6O #visualization #infographics"                       |
| 11  | "Fri Oct 09 12:33:50 +0000 2015" | "Julia 0.4 Release Announcement http://t.co/jqaKWflomJ #julialang"                                                |
| 12  | "Fri Oct 09 12:04:22 +0000 2015" | "User-friendly scaling http://t.co/P9rYu38FeD #rstats"                                                            |
| 13  | "Thu Oct 08 16:03:37 +0000 2015" | "#MonthOfJulia Day 31: Regression http://t.co/HBJv5xDHcy #julialang"                                              |
| 14  | "Thu Oct 08 15:33:06 +0000 2015" | "MIT Master's Program To Use MOOCs As 'Admissions Test' http://t.co/OjF8CVYBzW #slashdot"                         |
| 15  | "Thu Oct 08 06:03:36 +0000 2015" | "Announcing: Calls For Speakers For 2016 Conferences http://t.co/HOqzeAJ3Bx #Presentation #speaking"              |
| 16  | "Wed Oct 07 21:05:45 +0000 2015" | "Spark Turns Five Years Old! http://t.co/TislhgsDrz #bigdata"                                                     |
| 17  | "Wed Oct 07 21:03:49 +0000 2015" | "5 Reasons To Learn Hadoop http://t.co/ZdmSdkoJUI #bigdata"                                                       | 
| 18  | "Wed Oct 07 16:04:56 +0000 2015" | "#MonthOfJulia Day 30: Clustering http://t.co/dh6AUqSqKe #julialang"                                              |
| 19  | "Wed Oct 07 15:01:04 +0000 2015" | "#MonthOfJulia Day 30: Clustering http://t.co/IEm60jRNYp http://t.co/tn9iZ65L4j"                                  |
| 20  | "Wed Oct 07 00:34:48 +0000 2015" | "What is Hadoop? Great Infographics Explains How it Works http://t.co/36Cm2raL1w #visualization #infographics"    |
{{< /highlight >}}

You can have a lot of fun playing around with the features in the Twitter API. Trust me.

## HTTP Servers

The [HttpServer](https://github.com/JuliaWeb/HttpServer.jl) package provides low level functionality for implementing a HTTP server in Julia. The [Mux](https://github.com/one-more-minute/Mux.jl) package implements a higher level of abstraction. There are undoubtedly easier ways of serving your HTTP content, but being able to do it from the ground up in Julia is cool if nothing else!

That's it for today. I realise that I have already broken through the "month" boundary. I still have a few more topics that I want to cover. It might end up being something more like "A Month and a Week of Julia".

<iframe width="560" height="315" src="https://www.youtube.com/embed/qYjHYTn7r2w" frameborder="0" allowfullscreen></iframe>
