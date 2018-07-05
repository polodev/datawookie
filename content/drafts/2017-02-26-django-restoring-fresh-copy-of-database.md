---
draft: true
title: 'Django: Restoring Fresh Copy of Database'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
> Restore fresh database
> 
> When you backup whole database by using dumpdata command, it will backup all the database tables
  
> If you use this database dump to load the fresh database(in another django project), it can be causes IntegrityError (If you loaddata in same database it works fine)
  
> To fix this problem, make sure to backup the database by excluding contenttypes and auth.permissions tables
  
> ./manage.py dumpdata &#8211;exclude auth.permission &#8211;exclude contenttypes > db.json
  
> Now you can use loaddata command with a fresh database
  
> ./manage.py loaddata db.json 

Before you restore the data you need to setup the tables.
  
[code language=&#8221;bash&#8221; gutter=&#8221;false&#8221;]
  
$ python3 manage.py migrate
