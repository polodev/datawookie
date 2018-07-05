---
draft: true
title: 'Django: Meddling with Migrations'
author: andrew
type: post
date: 2017-02-26T08:22:10+00:00
categories:
  - Django

---
migrate &#8211;fake-initial

<blockquote data-secret="UbLFQ0IRam" class="wp-embedded-content">
  <p>
    <a href="https://www.algotech.solutions/blog/python/django-migrations-and-how-to-manage-conflicts/">Django Migrations and How to Manage Conflicts</a>
  </p>
</blockquote>



http://stackoverflow.com/questions/29888046/django-1-8-create-initial-migrations-for-existing-schema

http://stackoverflow.com/questions/30626886/how-to-redo-a-migration-on-django-1-8-after-using-fake

https://docs.djangoproject.com/en/1.8/topics/migrations/

## Version Control

My OCD side objected to these obscurely named migration files. So for a while I&#8217;d just delete them all from time to time.

Big mistake.

Seriously, this kind of reckless behaviour will result in a whole world of pain.

Do youself a favour and treasure those migrations. Keep careful account of them with version control.
