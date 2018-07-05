https://rstudio-pubs-static.s3.amazonaws.com/279354_f552c4c41852439f910ad620763960b6.html
draft: true

THIS HAS A USEFUL SECTION ON ENCODINGS: https://medium.com/@peterjgensler/functions-with-r-and-rvest-a-laymens-guide-acda42325a77

## Identifying Encoding

Using `file` you can get an idea of a file's encoding. Here are some possibilities:

- ASCII text
- UTF-8 Unicode text
- UTF-8 Unicode (with BOM) text
- Non-ISO extended-ASCII text

## Simple Approach

A reasonable initial approach is simply guessing.

{% highlight bash %}
$ iconv -f latin1 -t UTF-8 input-file.txt
{% endhighlight %}

## ENCA

[enca](http://freecode.com/projects/enca) is a useful tool for detecting a file's encoding.

{% highlight bash %}
$ sudo apt install enca
{% endhighlight %}

{% highlight bash %}
$ enca --list languages
belarusian: CP1251 IBM866 ISO-8859-5 KOI8-UNI maccyr IBM855 KOI8-U
 bulgarian: CP1251 ISO-8859-5 IBM855 maccyr ECMA-113
     czech: ISO-8859-2 CP1250 IBM852 KEYBCS2 macce KOI-8_CS_2 CORK
  estonian: ISO-8859-4 CP1257 IBM775 ISO-8859-13 macce baltic
  croatian: CP1250 ISO-8859-2 IBM852 macce CORK
 hungarian: ISO-8859-2 CP1250 IBM852 macce CORK
lithuanian: CP1257 ISO-8859-4 IBM775 ISO-8859-13 macce baltic
   latvian: CP1257 ISO-8859-4 IBM775 ISO-8859-13 macce baltic
    polish: ISO-8859-2 CP1250 IBM852 macce ISO-8859-13 ISO-8859-16 baltic CORK
   russian: KOI8-R CP1251 ISO-8859-5 IBM866 maccyr
    slovak: CP1250 ISO-8859-2 IBM852 KEYBCS2 macce KOI-8_CS_2 CORK
   slovene: ISO-8859-2 CP1250 IBM852 macce CORK
 ukrainian: CP1251 IBM855 ISO-8859-5 CP1125 KOI8-U maccyr
   chinese: GBK BIG5 HZ
      none:
{% endhighlight %}

## Using hexdump to Diagnose 

If you find that there are a few offending characters in a file (for example, `iconv` might warn about an "illegal input sequence") then you will find `hexdump` to be invaluable.

By default `hexdump` will generate file offsets in hexadecimal. However it provides vast flexibility in fine tuning its output via the `-e` option. This will produce output with decimal offsets.

{% highlight bash %}
$ hexdump -v -e '"%010_ad  |" 16/1 "%_p" "|\n"' input-file.txt
{% endhighlight %}
