---
author: Andrew B. Collier
date: 2015-09-09T13:00:13Z
tags: ["Julia"]
title: 'MonthOfJulia Day 10: Modules'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Module.png" >

Modules allow you to encapsulate your code and variables. In the words of the Julia documentation:

<blockquote>
Modules in Julia are separate global variable workspaces. Modules allow you to create top-level definitions without worrying about name conflicts when your code is used together with somebody else’s. Within a module, you can control which names from other modules are visible (via importing), and specify which of your names are intended to be public (via exporting).
<cite><a href="http://julia.readthedocs.org/en/latest/manual/modules/">Modules</a>, Julia Documentation</cite>
</blockquote>

To illustrate the concept, let's define two new modules:
  
{{< highlight julia >}}
julia> module AfrikaansModule
       __init__() = println("Initialising the Afrikaans module.")
       greeting() = "Goeie môre!"
       bonappetit() = "Smaaklike ete"
       export greeting
       end
Initialising the Afrikaans module.
julia> module ZuluModule
       greeting() = "Sawubona!"
       bonappetit() = "Thokoleza ukudla"
       end
{{< /highlight >}}
  
If an `__init__()` function is present in the module then it's executed when the module is defined. Is it my imagination or does the syntax for that function have an uncanny resemblance to something in another popular scripting language?

The greeting() function in the above modules does not exist in the global namespace (which is why the first function call below fails). But you can access functions from either of the modules by explicitly giving the module name as a prefix.
  
{{< highlight julia >}}
julia> greeting()
ERROR: greeting not defined
julia> AfrikaansModule.greeting()
"Goeie môre!"
julia> ZuluModule.greeting()
"Sawubona!"
{{< /highlight >}}

The Afrikaans module exports the greeting() function, which becomes available in the global namespace once the module has been loaded.
  
{{< highlight julia >}}
julia> using AfrikaansModule
julia> greeting()
"Goeie môre!"
{{< /highlight >}}

But it's still possible to import into the global namespace functions which have not been exported.
  
{{< highlight julia >}}  
julia> import ZuluModule.bonappetit
julia> bonappetit()
"Thokoleza ukudla"
{{< /highlight >}}

In addition to functions, modules can obviously also encapsulate variables.

That's pretty much the essence of it although there are a number of subtleties detailed in the [official documentation](http://julia.readthedocs.org/en/latest/manual/modules/). Well worth a look if you want to suck all the marrow out of Julia's modules. As usual the code for today's flirtation can be found on [github](https://github.com/DataWookie/MonthOfJulia).
