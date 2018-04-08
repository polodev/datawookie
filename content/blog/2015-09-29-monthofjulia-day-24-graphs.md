---
author: Andrew B. Collier
date: 2015-09-29T15:00:28Z
tags: ["Julia"]
title: 'MonthOfJulia Day 24: Graphs'
---

<!--more-->

<img src="/img/2015/09/Julia-Logo-Graphs.png" >

If you're not too familiar Graph Theory, then it might be an idea to take a moment to [get the basics](https://en.wikipedia.org/wiki/Graph_theory). Graphs are an extremely versatile data structure for storing data consisting of linked entities. I'm going to look at two packages for managing graphs in Julia: [LightGraphs](https://github.com/JuliaGraphs/LightGraphs.jl) and [Graphs](https://github.com/JuliaLang/Graphs.jl).

## LightGraphs

As usual, the first step is to load the package.

{{< highlight julia >}}
julia> using LightGraphs
{{< /highlight >}}

LightGraphs has methods which generate a selection of standard graphs like `StarGraph()`, `WheelGraph()` and `FruchtGraph()`. There are also functions for random graphs, for example, `erdos_renyi()` and `watts_strogatz()`. We'll start off by creating two small graphs. One will have 10 nodes connected by 20 random edges. The other will be a directed star graph consisting of four nodes, the central node being connected to every other node.

{{< highlight julia >}}
julia> g1 = Graph(10, 20)
{10, 20} undirected graph
julia> g2 = StarDiGraph(4)
{4, 3} directed graph
julia> edges(g2)
Set{Pair{Int64,Int64}}({edge 1 - 2,edge 1 - 4,edge 1 - 3})
{{< /highlight >}}

It's simple to find the [degree](https://en.wikipedia.org/wiki/Graph_theory#Definitions) and neighbours of a given node.

{{< highlight julia >}}
julia> degree(g1, 4) # How many neighbours for vertex 4?
6
julia> neighbors(g1, 4) # Find neighbours of vertex 4
6-element Array{Int64,1}:
 1
 3
 6
 2
 9
 7
{{< /highlight >}}

There's a straightforward means to add and remove edges from the graph.

{{< highlight julia >}}
julia> add_edge!(g1, 4, 8) # Add edge between vertices 4 and 8
edge 4 - 8
julia> rem_edge!(g1, 4, 6) # Remove edge between vertices 4 and 6
edge 6 - 4
{{< /highlight >}}

The package has functionality for performing high level tests on the graph (checking, for instance, whether it is cyclic or connected). There's also support for path based algorithms, but we'll dig into those when we look at the Graphs package.

## Graphs

Before we get started with the Graphs package you might want to restart your Julia session to purge all of that LightGraphs goodness. Take a moment to browse the [Graphs.jl documentation](http://graphsjl-docs.readthedocs.org/en/latest/), which is very comprehensive.

{{< highlight julia >}}
julia> using Graphs
{{< /highlight >}}

As with LightGraphs, there are numerous options for generating standard graphs.

{{< highlight julia >}}
julia> g1a = simple\_frucht\_graph()
Undirected Graph (20 vertices, 18 edges)
julia> g1b = simple\_star\_graph(8)
Directed Graph (8 vertices, 7 edges)
julia> g1c = simple\_wheel\_graph(8)
Directed Graph (8 vertices, 14 edges)
{{< /highlight >}}

Graphs uses the [GraphViz](https://github.com/Keno/GraphViz.jl) library to generate plots.

{{< highlight julia >}}
julia> plot(g1a)
{{< /highlight >}}

<img src="/img/2015/09/sample-graph.png" >

Of course, a graph can also be constructed manually.

{{< highlight julia >}}
julia> g2 = simple_graph(4)
Directed Graph (4 vertices, 0 edges)
julia> add_edge!(g2, 1, 2)
edge [1]: 1 - 2
julia> add_edge!(g2, 1, 3)
edge [2]: 1 - 3
julia> add_edge!(g2, 2, 3)
edge [3]: 2 - 3
{{< /highlight >}}

Individual vertices (a vertex is the same as a node) can be interrogated. Since we are considering a directed graph we look separately at the edges exiting and entering a node.

{{< highlight julia >}}
julia> num_vertices(g2)
4
julia> vertices(g2)
1:4
julia> out_degree(1, g2)
2
julia> out_edges(1, g2)
2-element Array{Edge{Int64},1}:
 edge [1]: 1 - 2
 edge [2]: 1 - 3
julia> in_degree(2, g2)
1
julia> in_edges(2, g2)
1-element Array{Edge{Int64},1}:
 edge [1]: 1 - 2
{{< /highlight >}}

Vertices can be created with labels and attributes.

{{< highlight julia >}}
julia> V1 = ExVertex(1, "V1");
julia> V1.attributes["size"] = 5.0
5.0
julia> V2 = ExVertex(2, "V2");
julia> V2.attributes["size"] = 3.0
3.0
julia> V3 = ExVertex(3, "V3")
vertex [3] "V3"
{{< /highlight >}}

Those vertices can then be used to define edges, which in turn can have labels and attributes.

{{< highlight julia >}}
julia> E1 = ExEdge(1, V1, V2)
edge [1]: vertex [1] "V1" - vertex [2] "V2"
julia> E1.attributes["distance"] = 50
50
julia> E1.attributes["color"] = "green"
"green"
{{< /highlight >}}

Finally the collection of vertices and edges can be gathered into a graph.

{{< highlight julia >}}
julia> g3 = edgelist([V1, V2], [E1], is_directed = true)
Directed Graph (2 vertices, 1 edges)
{{< /highlight >}}

It's possible to systematically visit all connected vertices in a graph, applying an operation at every vertex. `traverse_graph()` performs the graph traversal using either a depth first or breadth first algorithm. In the sample code below the operation applied at each vertex is `LogGraphVisitor()`, which is a simple logger.

{{< highlight julia >}}
julia> traverse_graph(g1c, DepthFirst(), 1, LogGraphVisitor(STDOUT))
discover vertex: 1
examine neighbor: 1 -> 2 (vertexcolor = 0, edgecolor= 0)
discover vertex: 2
open vertex: 2
examine neighbor: 2 -> 3 (vertexcolor = 0, edgecolor= 0)
discover vertex: 3
open vertex: 3
examine neighbor: 3 -> 4 (vertexcolor = 0, edgecolor= 0)
discover vertex: 4
open vertex: 4
examine neighbor: 4 -> 5 (vertexcolor = 0, edgecolor= 0)
discover vertex: 5
open vertex: 5
examine neighbor: 5 -> 6 (vertexcolor = 0, edgecolor= 0)
discover vertex: 6
open vertex: 6
examine neighbor: 6 -> 7 (vertexcolor = 0, edgecolor= 0)
discover vertex: 7
open vertex: 7
examine neighbor: 7 -> 8 (vertexcolor = 0, edgecolor= 0)
discover vertex: 8
open vertex: 8
examine neighbor: 8 -> 2 (vertexcolor = 1, edgecolor= 0)
close vertex: 8
close vertex: 7
close vertex: 6
close vertex: 5
close vertex: 4
close vertex: 3
close vertex: 2
examine neighbor: 1 -> 3 (vertexcolor = 2, edgecolor= 0)
examine neighbor: 1 -> 4 (vertexcolor = 2, edgecolor= 0)
examine neighbor: 1 -> 5 (vertexcolor = 2, edgecolor= 0)
examine neighbor: 1 -> 6 (vertexcolor = 2, edgecolor= 0)
examine neighbor: 1 -> 7 (vertexcolor = 2, edgecolor= 0)
examine neighbor: 1 -> 8 (vertexcolor = 2, edgecolor= 0)
close vertex: 1
{{< /highlight >}}

We can use [Dijkstra's Algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm) to calculate the distance from a given vertex to all other vertices in the graph. We see, for instance, that the distance from vertex 1 to vertex 4 is three steps. Since vertex 1 and vertex 20 are not connected, the distance between them is infinite. There are a couple of other algorithms available for calculating shortest paths.

{{< highlight julia >}}
julia> distances = ones(num_edges(g1a)); # Assign distance of 1 to each edge.
julia> d = dijkstra\_shortest\_paths(g1a, distances, 1);
julia> d.dists # Vector of distances to all other vertices.
20-element Array{Float64,1}:
   0.0
   1.0
   2.0
   3.0
   3.0
   2.0
   1.0
   1.0
   3.0
   4.0
   2.0
   2.0
   Inf
   Inf
   Inf
   Inf
   Inf
   Inf
   Inf
   Inf
{{< /highlight >}}

As with the most of the packages that I have looked at already, the functionality summarised above is just a small subset of what's available. Have a look at the home pages for these packages and check out the full code for today (which looks at a number of other features) on [github](https://github.com/DataWookie/MonthOfJulia). Some time in the future I plan on looking at the [EvolvingGraphs](https://github.com/weijianzhang/EvolvingGraphs.jl) which caters for graphs where the structure changes with time.

<center>
  <a href="http://spikedmath.com/493.html">
    <img src="/img/2015/09/493-drawing-stars-0.png" >
  </a>
</center>
