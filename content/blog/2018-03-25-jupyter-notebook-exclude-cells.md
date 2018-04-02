---
author: Andrew B. Collier
date: 2018-03-25T08:00:00Z
excerpt_separator: <!-- more -->
title: Using Tags to Exclude Cells from Jupyter Notebook
draft: true
tags: ["Jupyter"]
---

I use Jupyter Notebooks a lot for teaching and giving presentations. One of the issues that I have wrestled with is finding an efficient way to incorporate exercises into the material. I want to have the solutions embedded in the notebooks but need to have some way of filtering them out of the material that I provide to the audience. Otherwise it's just too easy for them to look at the solutions without actually trying to do the exercises themselves.

I think I now have a good solution though. It's based on tags, which are a Jupyter feature I was completely unaware of until a few days ago.

You can enable tags via the menu system using View → Cell Toolbar → Tags.

![](/img/2018/03/jupyter-exercise-tag.png)

These are the tags I'm using at present:

- `exercise` for all cells relating to an exercise;
- `working` for a cell set aside for typing up a solution; and
- `solution` for one or more cells containing a reference solution.

https://stackoverflow.com/questions/31517194/how-to-hide-one-specific-cell-input-or-output-in-ipython-notebook
https://groups.google.com/forum/m/#!topic/jupyter/W2M_nLbboj4 [lots of details]
http://nbconvert.readthedocs.io/en/latest/usage.html#convert-notebook
http://www.i-programmer.info/news/216-python/10663-jupyter-notebook-5-adds-cell-tagging.html
https://github.com/jupyter/nbconvert/issues/764

Works with HTML output:

jupyter nbconvert nbconvert-example.ipynb --TagRemovePreprocessor.remove_cell_tags='{"solution"}'

But not with notebook output:

jupyter nbconvert --to notebook nbconvert-example.ipynb --TagRemovePreprocessor.remove_cell_tags='{"solution"}'

But it is just JSON so we should be able to parse and remove.