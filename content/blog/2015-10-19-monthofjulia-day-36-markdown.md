---
author: Andrew B. Collier
date: 2015-10-19T15:00:58Z
tags: ["Julia"]
title: 'MonthOfJulia Day 36: Markdown'
---

<!--more-->

<img src="/img/2015/10/Julia-Logo-Markdown.png" >

[Markdown](https://en.wikipedia.org/wiki/Markdown) is a lightweight format specification language developed by [John Gruber](https://daringfireball.net/projects/markdown/). Markdown can be converted to HTML, [LaTeX](https://www.latex-project.org/) or other document formats. You probably knew all that already. The syntax is pretty simple. Check out this useful [cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

In the latest stable version of Julia support for markdown is provided in the Base package.

{{< highlight julia >}}
julia> using Base.Markdown
julia> import Base.Markdown: MD, Paragraph, Header, Italic, Bold, LineBreak, plain, term, html,
                             Table, Code, LaTeX, writemime
{{< /highlight >}}

Markdown is stored in objects of type `Base.Markdown.MD`. As you'll see below, there are at least two ways to construct markdown objects: either directly from a string (using markdown syntax) or programmatically (using a selection of formatting functions).

{{< highlight julia >}}
julia> d1 = md"foo \*italic foo\* \*\*bold foo\*\* \`code foo\`";
julia> d2 = MD(Paragraph(["foo ", Italic("italic foo"), " ", Bold("bold foo"), " ",
               Code("code foo")]));
julia> typeof(d1)
Base.Markdown.MD
julia> d1 == d2
true
{{< /highlight >}}

You'll find that `Base.Markdown.MD` objects are rendered with appropriate formatting in your console.

<img src="/img/2015/10/julia-console-markdown.jpg" >

Functions `html()` and `latex()` convert `Base.Markdown.MD` objects into other formats. Another way of rendering markdown elements is with `writemime()`, where the output is determined by specifying a [MIME type](https://en.wikipedia.org/wiki/MIME).

{{< highlight julia >}}
julia> html(d1)
"<p>foo <em>italic foo</em> <strong>bold foo</strong> <code>code foo</code></p>\n"
julia> latex(d1)
"foo \\emph{italic foo} \\textbf{bold foo} \\texttt{code foo}\n"
{{< /highlight >}}

Markdown has support for section headers, both ordered and unordered lists, tables, code fragments and block quotes.

{{< highlight julia >}}
julia> d3 = md"""# Chapter Title
       ## Section Title
       ### Subsection Title""";
julia> d4 = MD(Header{2}("Section Title"));
julia> d3 |> html
"<h1>Chapter Title</h1>\n<h2>Section Title</h2>\n<h3>Subsection Title</h3>\n"
julia> latex(d4)
"\\subsection{Section Title}\n"
{{< /highlight >}}

Most Julia packages come with a `README.md` markdown file which provides an overview of the package. The `readme()` function gives you direct access to these files' contents.

{{< highlight julia >}}
julia> readme("Quandl")
  Quandl.jl
  ============
  (Image: Build Status)
  (Image: Coverage Status)
  (Image: Quandl)
  
  Documentation is provided by Read the Docs.
  
  See the Quandl API Help Page for further details about the Quandl API. This package
  closely follows the nomenclature used by that documentation.
{{< /highlight >}}
We can also use `parse_file()` to treat the contents of a file as markdown.
{{< highlight julia >}}
julia> d6 = Markdown.parse_file(joinpath(homedir(), ".julia/v0.4/NaNMath/README.md"));
{{< /highlight >}}

This is rendered below as LaTeX.

{{< highlight latex >}}
\section{NaNMath}
Implementations of basic math functions which return \texttt{NaN} instead of throwing a
\texttt{DomainError}.
Example:
\begin{verbatim}
import NaNMath
NaNMath.log(-100) # NaN
NaNMath.pow(-1.5,2.3) # NaN
\end{verbatim}
In addition this package provides functions that aggregate one dimensional arrays and ignore
elements that are NaN. The following functions are implemented:
\begin{verbatim}
sum
maximum
minimum
mean
var
std
\end{verbatim}
Example:
\begin{verbatim}
using NaNMath; nm=NaNMath
nm.sum([1., 2., NaN]) # result: 3.0
\end{verbatim}
\href{https://travis-ci.org/mlubin/NaNMath.jl}{\begin{figure}
\centering
\includegraphics{https://travis-ci.org/mlubin/NaNMath.jl.svg?branch=master}
\caption{Build Status}
\end{figure}
}
{{< /highlight >}}

And here it is as HTML.

<div style="background-color: #96C0CE; padding: 0px 24px">
  <h1>
    NaNMath
  </h1>

  <p>
    Implementations of basic math functions which return <code>NaN</code> instead of throwing a <code>DomainError</code>.<br /> Example:
  </p>

<pre><code class="language-julia">import NaNMath
NaNMath.log&#40;-100&#41; # NaN
NaNMath.pow&#40;-1.5,2.3&#41; # NaN</code>
</pre>

  <p>
    In addition this package provides functions that aggregate one dimensional arrays and ignore elements that are NaN. The following functions are implemented:
  </p>

  <pre><code>
sum
maximum
minimum
mean
var
std</code></pre>

  <p>
    Example:
  </p>

  <pre><code class="language-julia">using NaNMath; nm&#61;NaNMath
nm.sum&#40;&#91;1., 2., NaN&#93;&#41; # result: 3.0</code></pre>

  <p>
    <a href="https://travis-ci.org/mlubin/NaNMath.jl">
      <img src="https://travis-ci.org/mlubin/NaNMath.jl.svg?branch&#61;master" alt="Build Status" />
    </a>
  </p>
</div> 

What particularly appeals to me about the markdown functionality in Julia is the potential for automated generation of documentation and reports. To see more details of my dalliance with Julia and markdown, visit [github](https://github.com/DataWookie/MonthOfJulia).
