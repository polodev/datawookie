---
author: Andrew B. Collier
date: 2018-02-16T08:00:00Z
tags: ["SQL", "Linux"]
title: Installing DataGrip on Ubuntu
---

![](/img/logo/logo-datagrip.png)

1. [Download](https://www.jetbrains.com/datagrip/download/download-thanks.html) the DataGrip archive.
2. Unpack the archive.

    {{< highlight text >}}
$ tar -zxvf datagrip-2018.1.4.tar.gz 
{{< /highlight >}}

3. Rename the folder.

    {{< highlight text >}}
$ mv DataGrip-2018.1.4/ datagrip
{{< /highlight >}}

4. Change the owner to `root`.

    {{< highlight text >}}
$ chown -R root.root datagrip
{{< /highlight >}}

5. Move to `/opt`.

    {{< highlight text >}}
$ sudo mv datagrip /opt/
{{< /highlight >}}

6. Link it into `PATH`.

    {{< highlight text >}}
$ sudo ln -s /opt/datagrip/bin/datagrip.sh /usr/local/bin/datagrip
{{< /highlight >}}

7. Start it from the terminal.

    {{< highlight text >}}
$ datagrip
{{< /highlight >}}
