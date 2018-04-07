---
author: Andrew B. Collier
date: 2016-09-28T15:00:10Z
tags: ["MongoDB", "Python"]
title: 'Python: First Steps with MongoDB'
---

I'm busy working my way through Kyle Banker's [MongoDB in Action](https://www.manning.com/books/mongodb-in-action). Much of the example code in the book is given in Ruby. Despite the fact that I'd love to learn more about Ruby, for the moment it makes more sense for me to follow along with Python.

<!--more-->

<img src="/img/2016/09/mongodb-logo.png" >

## MongoDB Installation

If you haven't already installed [MongoDB](https://www.mongodb.com/), now is the time to do it! On a Debian Linux system the installation is very simple.

{{< highlight bash >}}
$ sudo apt install mongodb
{{< /highlight >}}

## Python Package Installation

Next install [PyMongo](https://github.com/mongodb/mongo-python-driver), the Python driver for MongoDB.

{{< highlight bash >}}
$ pip3 install pymongo
{{< /highlight >}}

Check that the install was successful.

{{< highlight python >}}
>>> import pymongo
>>> pymongo.version
'3.3.0'
{{< /highlight >}}

Detailed documentation for PyMongo can be found [here](https://api.mongodb.com/python/current/).

## Creating a Client

To start interacting with the MongoDB server we need to instantiate a `MongoClient`.

{{< highlight python >}}
>>> client = pymongo.MongoClient()
{{< /highlight >}}

This will connect to `localhost` using the default port. Alternative values for host and port can be specified.

## Connect to a Database

Next we connect to a particular database called `test`. If the database does not yet exist then it will be created.

{{< highlight python >}}
>>> db = client.test
{{< /highlight >}}

## Create a Collection

A database will hold one or more collections of documents. We'll create a `users` collection.

{{< highlight python >}}
>>> users = db.users
>>> users
Collection(Database(MongoClient(host=['localhost:27017'], document_class=dict, tz_aware=False, connect=True), 'test'), 'users')
{{< /highlight >}}

As mentioned in the documentation, MongoDB is lazy about the creation of databases and collections. Neither the database nor collection is actually created until data are written to them.

## Working with Documents

As you would expect, MongoDB caters for the four basic [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations.

### Create

Documents are represented as dictionaries in Python. We'll create a couple of light user profiles.

{{< highlight python >}}
>>> smith = {"last_name": "Smith", "age": 30}
>>> jones = {"last_name": "Jones", "age": 40}
{{< /highlight >}}

We use the `insert_one()` method to store each document in the collection.

{{< highlight python >}}
>>> users.insert_one(smith)
<pymongo.results.InsertOneResult object at 0x7f57d36d9678>
{{< /highlight >}}

Each document is allocated a unique identifier which can be accessed via the `inserted_id` attribute.

{{< highlight python >}}
>>> jones_id = users.insert_one(jones).inserted_id
>>> jones_id
ObjectId('57ea4adfad4b2a1378640b42')
{{< /highlight >}}

Although these identifiers look pretty random, there is actually a wel defined structure. The first 8 characters (4 bytes) are a timestamp, followed by a 6 character machine identifier then a 4 character process identifier and finally a 6 character counter.

We can verify that the collection has been created.

{{< highlight python >}}
>>> db.collection_names()
['users', 'system.indexes']
{{< /highlight >}}

There's also an `insert_many()` method which can be used to simultaneously insert multiple documents.

### Read

The `find_one()` method can be used to search the collection. As its name implies it only returns a single document.

{{< highlight python >}}
>>> users.find_one({"last_name": "Smith"})
{'_id': ObjectId('57ea4acfad4b2a1378640b41'), 'age': 30, 'last_name': 'Smith'}
>>> users.find_one({"_id": jones_id})
{'_id': ObjectId('57ea4adfad4b2a1378640b42'), 'age': 40, 'last_name': 'Jones'}
{{< /highlight >}}

A more general query can be made using the `find()` method which, rather than returning a document, returns a cursor which can be used to iterate over the results. With our minimal collection this doesn't seem very useful, but a cursor really comes into its own with a massive collection.

{{< highlight python >}}
>>> users.find({"last_name": "Smith"})
<pymongo.cursor.Cursor object at 0x7f57d77fe3c8>
>>> users.find({"age": {"$gt": 20}})
<pymongo.cursor.Cursor object at 0x7f57d77fe8d0>
{{< /highlight >}}

A cursor is an iterable and can be used to neatly access the query results.

{{< highlight python >}}
>>> cursor = users.find({"age": {"$gt": 20}})
>>> for user in cursor:
...     user["last_name"]
...  
'Smith'
'Jones'
{{< /highlight >}}

Operations like `count()` and `sort()` can be applied to the results returned by `find()`.

### Update

The `update()` method is used to modify existing documents. A compound document is passed as the argument to `update()`, the first part of which is used to match those documents to which the change is to be applied and the second part gives the details of the change.

{{< highlight python >}}
>>> users.update({"last_name": "Smith"}, {"$set": {"city": "Durban"}})
{'updatedExisting': True, 'nModified': 1, 'n': 1, 'ok': 1}
{{< /highlight >}}

The example above uses the `$set` modifier. There are a number of [other modifiers](https://docs.mongodb.com/manual/reference/operator/update/#id1) available like `$inc`, `$mul`, `$rename` and `$unset`.

By default the update is only applied to the first matching record. The change can be applied to all matching records by specifying `multi = True`.

### Delete

Deleting records happens via the `remove()` method with an argument which specifies which records are to be deleted.

{{< highlight python >}}
>>> users.remove({"age": {"$gte": 40}})
{'n': 1, 'ok': 1}
{{< /highlight >}}

## Conclusion

Well those are the basic operations. Nothing too scary. I'll be back with the Python implementation of the Twitter archival sample application.
