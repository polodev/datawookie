---
author: Andrew B. Collier
date: 2016-08-31T06:00:51Z
tags: ["R"]
title: 'ubeR: A Package for the Uber API'
---

Uber exposes an extensive API for interacting with their service. [ubeR](https://github.com/DataWookie/ubeR) is a R package for working with that API which Arthur Wu and I put together during a Hackathon at iXperience.

<img class="style-svg" alt="alt-text" src="https://cdn.rawgit.com/DataWookie/ubeR/master/uber-logo.svg" />

## Installation

The package is currently hosted on GitHub. Installation is simple using the `devtools` package.

{{< highlight r >}}
> devtools::install_github("DataWookie/ubeR")
> library(ubeR)
{{< /highlight >}}

## Authentication

To work with the API you'll need to [create a new application](https://developer.uber.com/dashboard/create) for the Rides API.

* Set Redirect URL to http://localhost:1410/. 
* Enable the `profile`, `places`, `ride_widgets`, `history_lite` and `history` scopes. </ul> 
With the resulting Client ID and Client Secret you'll be ready to authenticate. I've stored mine as environment variables but you can just hard code them into the script for starters.

{{< highlight r >}}
> UBER_CLIENTID = Sys.getenv("UBER_CLIENTID")
> UBER_CLIENTSECRET = Sys.getenv("UBER_CLIENTSECRET")
>
> uber_oauth(UBER_CLIENTID, UBER_CLIENTSECRET)
{{< /highlight >}}

## Identity

We can immediately use `uber_me()` to retrieve information about the authenticated user.

{{< highlight r >}}
> identity <- uber_me()
> names(identity)
[1] "picture"         "first_name"      "last_name"       "uuid"            "rider_id"       
[6] "email"           "mobile_verified" "promo_code"   
> identity$first_name
[1] "Andrew"
> identity$picture
[1] "https://d1w2poirtb3as9.cloudfront.net/default.jpeg"
{{< /highlight >}}

Clearly I haven't made enough effort in personalising my Uber account.

![](https://d1w2poirtb3as9.cloudfront.net/default.jpeg)

## Designated Places

Uber allows you to specify predefined locations for "home" and "work". These are accessible via `uber_places_get()`.

{{< highlight r >}}
> uber_places_get("home")
$address
[1] "St Andrews Dr, Durban North, 4051, South Africa"

> uber_places_get("work")
$address
[1] "Dock Rd, V & A Waterfront, Cape Town, 8002, South Africa"
{{< /highlight >}}

These addresses can be modified using `uber_places_put()`.

## History

You can access data for recent rides using `uber_history()`.

{{< highlight r >}}
> history <- uber_history(50, 0)
> names(history)
 [1] "status"       "distance"     "request_time" "start_time"   "end_time"     "request_id"  
 [7] "product_id"   "latitude"     "display_name" "longitude"
{{< /highlight >}}

The response includes a wide range of fields, we'll just pick out just a few of them for closer inspection.

{{< highlight r >}}
> head(history)[, c(2, 4:5, 9)]
  distance          start_time            end_time  display_name
1   1.3140 2016-08-15 17:35:24 2016-08-15 17:48:54 New York City
2  13.6831 2016-08-11 15:29:58 2016-08-11 16:04:22     Cape Town
3   2.7314 2016-08-11 09:09:25 2016-08-11 09:23:51     Cape Town
4   3.2354 2016-08-10 19:28:41 2016-08-10 19:38:07     Cape Town
5   7.3413 2016-08-10 16:37:30 2016-08-10 17:21:16     Cape Town
6   4.3294 2016-08-10 13:38:49 2016-08-10 13:59:00     Cape Town
{{< /highlight >}}

## Product Descriptions

We can get a list of cars near to a specified location using `uber_products()`.

{{< highlight r >}}
> cars <- uber_products(latitude = -33.925278, longitude = 18.423889)
> names(cars)
[1] "capacity"          "product_id"        "price_details"     "image"            
[5] "cash_enabled"      "shared"            "short_description" "display_name"     
[9] "description"  
> cars[, c(1, 2, 7)]
  capacity                           product_id short_description
1        4 91901472-f30d-4614-8ba7-9fcc937cebf5             uberX
2        6 419f6bdc-7307-4ea8-9bb0-2c7d852b616a            uberXL
3        4 1dd39914-a689-4b27-a59d-a74e9be559a4         UberBLACK
{{< /highlight >}}

Information for a particular car can also be accessed.

{{< highlight r >}}
> product <- uber_products(product_id = "91901472-f30d-4614-8ba7-9fcc937cebf5")
> names(product)
[1] "capacity"          "product_id"        "price_details"     "image"            
[5] "cash_enabled"      "shared"            "short_description" "display_name"     
[9] "description"      
> product$price_details
$service_fees
list()

$cost_per_minute
[1] 0.7

$distance_unit
[1] "km"

$minimum
[1] 20

$cost_per_distance
[1] 7

$base
[1] 5

$cancellation_fee
[1] 25

$currency_code
[1] "ZAR"
{{< /highlight >}}

## Estimates

It's good to have a rough idea of how much a ride is going to cost you. What about a trip from Mouille Point to the Old Biscuit Mill?

<img src="/img/2016/08/old-biscuit-mill.png">

{{< highlight r >}}
> estimate <- uber_requests_estimate(start_latitude = -33.899656, start_longitude = 18.407663,
+                                    end_latitude = -33.927443, end_longitude = 18.457557)
> estimate$trip
$distance_unit
[1] "mile"

$duration_estimate
[1] 600

$distance_estimate
[1] 4.15

> estimate$pickup_estimate
[1] 4
> estimate$price
  high_amount display_amount display_name low_amount surge_multiplier currency_code
1        5.00           5.00    Base Fare       5.00                1           ZAR
2       56.12    42.15-56.12     Distance      42.15                1           ZAR
3        8.30      6.23-8.30         Time       6.23                1           ZAR
{{< /highlight >}}

Not quite sure why the API is returning the distance in such obscure units. (Note to self: convert those to metric equivalent in next release!) The data above are based on the car nearest to the start location. What about prices for a selection of other cars?

{{< highlight r >}}
> estimate <- uber_estimate_price(start_latitude = -33.899656, start_longitude = 18.407663,
+                     end_latitude = -33.927443, end_longitude = 18.457557)
> names(estimate)
 [1] "localized_display_name" "high_estimate"          "minimum"                "duration"
 [5] "estimate"               "distance"               "display_name"           "product_id"
 [9] "low_estimate"           "surge_multiplier"       "currency_code"         
> estimate[, c(1, 5)]
  localized_display_name  estimate
1                  uberX  ZAR53-69
2                 uberXL  ZAR68-84
3              uberBLACK ZAR97-125
{{< /highlight >}}

The time of arrival for each of those cars can be accessed via `uber_estimate_time()`.

{{< highlight r >}}
> uber_estimate_time(start_latitude = -33.899656, start_longitude = 18.407663)
  localized_display_name estimate display_name                           product_id
1                  uberX      180        uberX 91901472-f30d-4614-8ba7-9fcc937cebf5
2                 uberXL      420       uberXL 419f6bdc-7307-4ea8-9bb0-2c7d852b616a
3              uberBLACK      300    uberBLACK 1dd39914-a689-4b27-a59d-a74e9be559a4
{{< /highlight >}}

So, for example, the uberXL would be expected to arrive in 7 minutes, while the uberX would pick you up in only 3 minutes.

## Requesting a Ride

It's also possible to request a ride. At present these requests are directed to the [Uber API Sandbox](https://developer.uber.com/docs/rides/sandbox). After we have done further testing we'll retarget the requests to the API proper.

A new ride is requested using `uber_requests()`.

{{< highlight r >}}
> ride <- uber_requests(start_address = "37 Beach Road, Mouille Point, Cape Town",
+                       end_address = "100 St Georges Mall, Cape Town City Centre, Cape Town")
{{< /highlight >}}

Let's find out the details of the result.

{{< highlight r >}}
> names(ride)
 [1] "status"           "destination"      "product_id"       "request_id"
 [5] "driver"           "pickup"           "eta"              "location"
 [9] "vehicle"          "surge_multiplier" "shared"     
> ride$pickup
$latitude
[1] -33.9

$longitude
[1] 18.406
> ride$destination
$latitude
[1] -33.924

$longitude
[1] 18.42
{{< /highlight >}}

Information about the currently requested ride can be accessed using `uber_requests_current()`. If we decide to walk instead, then it's also possible to cancel the pickup.

{{< highlight r >}}
> uber_requests_current_delete()
{{< /highlight >}}

## Future

For more information about units of measurement, limits and parameters of the Uber API, have a look at the [API Overview](https://developer.uber.com/docs/rides/api-overview).

We'll be extending the package to cover the remaining API endpoints. But, for the moment, most of the core functionality is already covered.

## Also Relevant

A nice [blog post](https://drsimonj.svbtle.com/plotting-my-trips-with-uber) by [Simon Jackson](https://twitter.com/drsimonj) who used ubeR to plot his recent trips.
