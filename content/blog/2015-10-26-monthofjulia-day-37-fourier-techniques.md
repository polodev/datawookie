---
author: Andrew B. Collier
date: 2015-10-26T15:00:47Z
tags: ["Julia"]
title: 'MonthOfJulia Day 37: Fourier Techniques'
---

<!--more-->

<img src="/img/2015/10/Julia-Logo-Fourier.png" >

The [Fourier Transform](https://en.wikipedia.org/wiki/Fourier_transform) is often applied to signal processing and other analyses. It allows a signal to be transformed between the [time domain](https://en.wikipedia.org/wiki/Time_domain) and the [frequency domain](https://en.wikipedia.org/wiki/Frequency_domain). The efficient [Fast Fourier Transform (FFT)](https://en.wikipedia.org/wiki/Fast_Fourier_transform) algorithm is implemented in Julia using the [FFTW](http://www.fftw.org/) library.

## 1D Fourier Transform

Let's start by looking at the Fourier Transform in one dimension. We'll create test data in the time domain using a wide [rectangle function](https://en.wikipedia.org/wiki/Rectangular_function).
  
{{< highlight julia >}}
julia> f = [abs(x) <= 1 ? 1 : 0 for x in -5:0.1:5];
julia> length(f)
101
{{< /highlight >}}
  
This is what the data look like:

<img src="/img/2015/10/signal-1D-time-domain.png" >
  
We'll transform the data into the frequency domain using `fft()`.
  
{{< highlight julia >}}
julia> F = fft(f);
julia> typeof(F)
Array{Complex{Float64},1}
julia> length(F)
101
julia> F = fftshift(F);
{{< /highlight >}}
  
The frequency domain data are an array of `Complex` type with the same length as the time domain data. Since each Complex number consists of two parts (real and imaginary) it seems that we have somehow doubled the information content of our signal. This is not true because half of the frequency domain data are redundant. The `fftshift()` function conveniently rearranges the data in the frequency domain so that the negative frequencies are on the left.

This is what the resulting amplitude and power spectra look like:

<img src="/img/2015/10/signal-1D-amplitude-spectrum-shifted.png" >

<img src="/img/2015/10/signal-1D-power-spectrum-shifted.png" >
  
The analytical Fourier Transform of the rectangle function is the [sinc function](https://en.wikipedia.org/wiki/Sinc_function), which agrees well with numerical data in the plots above.

## 2D Fourier Transform

Let's make things a bit more interesting: we'll look at the analogous two-dimensional problem. But this time we'll go in the opposite direction, starting with a two-dimensional sinc function and taking its Fourier Transform.

Building the array of sinc data is easy using a list comprehension.
  
{{< highlight julia >}}
julia> f = [(r = sqrt(x^2 + y^2); sinc(r)) for x in -6:0.125:6, y in -6:0.125:6];
julia> typeof(f)
Array{Float64,2}
julia> size(f)
(97,97)
{{< /highlight >}}
  
It doesn't make sense to think about a two-dimensional function in the time domain. But the Fourier Transform is quite egalitarian: it's happy to work with a temporal signal or a spatial signal (or a signal in pretty much any other domain). So let's suppose that our two-dimensional data are in the spatial domain. This is what it looks like:

<img src="/img/2015/10/function-2D-sinc.png" >

Generating the Fourier Transform is again a simple matter of applying `fft()`. No change in syntax: very nice indeed!
  
{{< highlight julia >}}
julia> F = fft(f);
julia> typeof(F)
Array{Complex{Float64},2}
julia> F = fftshift(F);
{{< /highlight >}}
  
The power spectrum demonstrates that the result is the 2D analogue of the rectangle function.

<img src="/img/2015/10/power-2D-sinc.png" >

## Higher Dimensions and Beyond

It's just as easy to apply the FFT to higher dimensional data, although in my experience this is rarely required.

Most of the [FFTW library's functionality](http://www.fftw.org/#features) has been implemented in the Julia interface. For example:

* it's possible to generate plans for optimised FFTs using `plan_fft()`; 
* `dct()` yields the Discrete Cosine Transform; 
* you can exploit conjugate symmetry in real transforms using `rfft()`; and 
* it's possible to run over multiple threads using `FFTW.set_num_threads()`.

Watch the video below in which Steve Johnson demonstrates many of the features of FFTs in Julia.

<iframe width="560" height="315" src="https://www.youtube.com/embed/1iBLaHGL1AM" frameborder="0" allowfullscreen></iframe>
