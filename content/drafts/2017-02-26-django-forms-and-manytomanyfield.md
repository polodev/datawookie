---
draft: true
title: 'Django: Forms and ManyToManyField'
author: andrew
type: post
date: 2017-02-26T08:21:59+00:00
categories:
  - Uncategorized

---
EITHER

register = form.save(commit = True)

OR

form = RegisterForm(request.POST, homeroom = homeroom)
      
if form.is_valid():
        
\# Create the model but do not commit to database.
        
#
        
register = form.save(commit = False)
        
#
        
\# Make ad hoc changes to register here&#8230;
        
#
        
register.save()
        
#
        
\# Commit the ManyToManyField data to database.
        
#
        
form.save_m2m()
