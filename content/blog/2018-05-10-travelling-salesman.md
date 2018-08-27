---
author: Andrew B. Collier
date: 2018-05-10T11:00:00Z
tags: ["R"]
title: Travelling Salesman with ggmap
---

I've been testing out some ideas around the [Travelling Salesman Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) using [TSP](https://cran.r-project.org/web/packages/TSP/) and [ggmap](https://cran.r-project.org/web/packages/ggmap/). <!--more--> For illustration I'll find the optimal route between the following addresses:

{{< highlight r >}}
ADDRESSES = c(
  "115 St Andrew's Drive, Durban North, KwaZulu-Natal, South Africa",
  "1 Evans Road, Glenwood, Berea, KwaZulu-Natal, South Africa",
  "7 Radar Drive, Durban North, KwaZulu-Natal, South Africa",
  "25 Gainsborough Drive, Durban North, KwaZulu-Natal, South Africa",
  "77 Armstrong Avenue, Umhlanga, KwaZulu-Natal, South Africa",
  "255 Musgrave Road, Berea, KwaZulu-Natal, South Africa",
  "11 Cassia Road, Reservoir Hills, Durban, KwaZulu-Natal, South Africa",
  "98 Shepstone Road, Berkshire Downs, New Germany, KwaZulu-Natal, South Africa",
  "12 Finchley Road, Berea West, Westville, KwaZulu-Natal, South Africa"
)
{{< /highlight >}}

Load up some packages.

{{< highlight r >}}
library(dplyr)
library(ggmap)
library(gmapsdistance)
library(TSP)
{{< /highlight >}}

## Geocoding

I added the latitude and longitude for each address using the handy `ggmap::mutate_geocode()`. I also added in a `latlon` column which is in the correct format for `gmapsdistance`.

{{< highlight r >}}
> addresses
# A tibble: 9 x 5
  label address                                                             lon   lat latlon              
  <chr> <chr>                                                             <dbl> <dbl> <chr>               
1 A     115 St Andrews Dr, Durban North, 4051, South Africa                31.0 -29.8 -29.778758+31.043515
2 B     1 Evans Rd, Glenwood, Berea, 4001, South Africa                    31.0 -29.9 -29.865966+30.992366
3 C     7 Radar Dr, Athlone, Durban North, 4051, South Africa              31.0 -29.8 -29.798012+31.033163
4 D     25 Gainsborough Dr, Athlone, Durban North, 4051, South Africa      31.0 -29.8 -29.795748+31.029069
5 E     77 Armstrong Ave, Umhlanga, 4051, South Africa                     31.1 -29.7 -29.746962+31.067561
6 F     255 Musgrave Rd, Musgrave, Berea, 4001, South Africa               31.0 -29.8 -29.844441+31.001648
7 G     11 Cassia Rd, Reservoir Hills, Durban, 4090, South Africa          30.9 -29.8 -29.794960+30.940820
8 H     98 Shepstone Rd, Berkshire Downs, New Germany, 3610, South Africa  30.9 -29.8 -29.797855+30.879264
9 I     12 Finchley Rd, Berea West, Westville, 3629, South Africa          30.9 -29.8 -29.838373+30.925782
{{< /highlight >}}

## Calculate Distance Matrix

Next I used `gmapsdistance::gmapsdistance()` to calculate the distances between all pairs of locations and converted the result into a distance matrix.

{{< highlight r >}}
> distances
       A      B      C      D      E      F      G      H
B 14.507                                                 
C  2.855 11.369                                          
D  2.931 11.884  1.311                                   
E  5.032 18.065  7.785  8.329                            
F 11.039  2.921  7.248  7.739 15.051                     
G 16.663 16.103 13.740 13.370 22.195 12.763              
H 22.166 19.120 19.243 18.873 27.698 18.916  7.480       
I 20.321 10.232 16.443 16.074 24.938 10.028  8.794 11.407
{{< /highlight >}}

## Solve the Travelling Salesman Problem

The TSP package provides a range of solution techniques for the Travelling Salesman Problem. I got decent results using the default optimisation.

{{< highlight r >}}
> tsp <- TSP(distances)
> tour <- solve_TSP(tsp)
> tour
object of class ‘TOUR’ 
result of method ‘arbitrary_insertion+two_opt’ for 9 cities
tour length: 68.406
{{< /highlight >}}

The length of the optimal tour is 68.4 km.

## Build Route and Plot

Finally I used `ggmap::route()` to build a route between the locations in the order specified by `tour` and plotted.

![](/img/2018/05/travelling-salesman-durban.png)

The code for this is available [here](https://github.com/DataWookie/travelling-salesman-map).