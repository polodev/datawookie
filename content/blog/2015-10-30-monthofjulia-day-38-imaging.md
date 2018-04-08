---
author: Andrew B. Collier
date: 2015-10-30T15:00:44Z
tags: ["Julia"]
title: 'MonthOfJulia Day 38: Imaging'
---

<!--more-->

<img src="/img/2015/10/Julia-Logo-Imaging.png">

Julia has a few packages aimed at image processing. We'll start by looking at the TestImages package, which hosts a selection of sample images, then briefly visit the ImageView package before moving onto the Images package, which implements a range of functions for image manipulation.

## Test Images

The TestImages package currently provides 25 sample images, which form a convenient basis for experimentation.

{{< highlight julia >}}
julia> using TestImages
julia> readdir(joinpath(homedir(), ".julia/v0.4/TestImages/images/"))
25-element Array{ByteString,1}:
 "autumn_leaves.png"
 "cameraman.tif"
 "earth_apollo17.jpg"
 "fabio.png"
 "house.tif"
 "jetplane.tif"
 "lake.tif"
 "lena_color_256.tif"
 "lena_color_512.tif"
 "lena_gray_256.tif"
 "lena_gray_512.tif"
 "lighthouse.png"
 "livingroom.tif"
 "mandril_color.tif"
 "mandril_gray.tif"
 "mandrill.tiff"
 "moonsurface.tiff"
 "mountainstream.png"
 "peppers_color.tif"
 "peppers_gray.tif"
 "pirate.tif"
 "toucan.png"
 "walkbridge.tif"
 "woman_blonde.tif"
 "woman_darkhair.tif"
{{< /highlight >}}

We'll load the archetypal test image (the November 1972 Playboy centerfold of [Lena Söderberg](https://en.wikipedia.org/wiki/Lenna)).

{{< highlight julia >}}
julia> lena = testimage("lena_color_256.tif");
{{< /highlight >}}

Of course, now that we've loaded that image, we'll want to take a look at it. To do that we'll need the ImageView package.

{{< highlight julia >}}
julia> using ImageView
julia> view(lena)
(ImageCanvas,ImageSlice2d: zoom = Graphics.BoundingBox(0.0,256.0,0.0,256.0))
{{< /highlight >}}

You can optionally specify the pixel spacing as a parameter to `view()`, which then ensures that the aspect ratio of the image is conserved on resizing. There are various other bobs and whistles associated with `view()`: you can click-and-drag within the image to zoom in on a particular region; various simple transformations (flipping and rotation) are possible; images can be annotated and multiple images can be arranged on a canvas for simultaneous viewing.

<img src="/img/2015/10/lena-color-512.png">

## Image Representation

Outside of the test images, an arbitrary image file can be loaded using `imread()` from the Images package. Naturally, there are also functions for writing images, `imwrite()` and `writemime()`.

{{< highlight julia >}}
julia> using Images
julia> earth = imread(joinpath(homedir(), ".julia/v0.4/TestImages/images/earth_apollo17.jpg"))
RGB Images.Image with:
  data: 3000x3002 Array{ColorTypes.RGB{FixedPointNumbers.UfixedBase{UInt8,8}},2}
  properties:
    IMcs: sRGB
    spatialorder: x y
    pixelspacing: 1 1
{{< /highlight >}}

The default representation for the `Image` object tells us its dimensions, storage type and colour space. The spatial order indicates that the image data are stored using row major ordering. It's also possible to specify physical units for the pixel spacing, which is particularly important if you are analysing images where absolute scale matters (for example, medical imaging). There are convenience methods for a few image properties.

{{< highlight julia >}}
julia> colorspace(earth)
"RGB"
julia> height(earth)
3002
julia> width(earth)
3000
{{< /highlight >}}

We can examine individual pixels within the image using the indexing operator.

{{< highlight julia >}}
julia> earth[1,1]
RGB{U8}(0.047,0.008,0.0)
{{< /highlight >}}

Each pixel is of type `RGB` (defined in the `Colors` package), which encapsulates a tuple giving the proportion of red, green and blue for that pixel. The underlying image data can also be accessed via the `data()` method.

<img src="/img/2015/10/earth_apollo17.jpg" width="100%">

The image can be split into its component colour channels using `separate()`.

{{< highlight julia >}}
julia> earth_rgb = separate(earth)
RGB Images.Image with:
  data: 3002x3000x3 Array{FixedPointNumbers.UfixedBase{UInt8,8},3}
  properties:
    IMcs: sRGB
    colorspace: RGB
    colordim: 3
    spatialorder: y x
    pixelspacing: 1 1
{{< /highlight >}}

Note that the result is a three-dimensional `Array`. The spatial order has also changed, which means that the data are now represented using column major ordering. The data are thus effectively transposed.

## Simple Image Processing

Kernel-based filtering can be applied using `imfilter()` or `imfilter_fft()`, where the latter is better suited to larger kernels. There's a variety of helper functions for constructing kernels, like `imaverage()` and `gaussian2d()`.

{{< highlight julia >}}
julia> lena_smooth = imfilter(lena, imaverage([3, 3]));
julia> lena_very_smooth = imfilter_fft(lena, ones(10, 10) / 100);
julia> lena_gauss_smooth = imfilter_gaussian(lena, [1, 2]);
{{< /highlight >}}

The effects of the above smoothing operations can be seen below, with the original image on the left, followed by the 3-by-3 and 10-by-10 boxcar filtered versions and finally the Gaussian filtered image.

<img src="/img/2015/10/lena-smooth-panel.png">

The `imgradients()` function calculates gradients across the image. You can choose from a set of methods for calculating the gradient. The morphological [dilation](https://en.wikipedia.org/wiki/Dilation_(morphology)) and [erosion](https://en.wikipedia.org/wiki/Erosion_(morphology)) operations are available via `dilate()` and `erode()`.

{{< highlight julia >}}
julia> (lena_sobel_x, lena_sobel_y) = imgradients(lena, "sobel");
julia> lena_dilate = dilate(lena);
julia> lena_erode = erode(lena);
{{< /highlight >}}

Below are the two components of the image gradient calculated using the [Sobel operator](https://en.wikipedia.org/wiki/Sobel_operator) followed by the results of `dilate()` and `erode()`.

<img src="/img/2015/10/lena-sobel.png">

<img src="/img/2015/10/lena-morphology.png">

## Other Packages

The ImageMagick package implements further imaging functionality. If, in the future, it provides an interface to the full functionality on the [ImageMagick suite](http://www.imagemagick.org/script/index.php) then it will be a truly phenomenal resource. Also worth looking at is the [PiecewiseAffineTransforms](https://github.com/dfdx/PiecewiseAffineTransforms.jl) package which implements a technique for warping portions of an image.

If you'd like to exercise your image processing and machine learning skills in Julia, take a look at the [First Steps With Julia](https://www.kaggle.com/c/street-view-getting-started-with-julia) competition on [kaggle](https://www.kaggle.com).

<iframe width="560" height="315" src="https://www.youtube.com/embed/FA-1B_amwt8" frameborder="0" allowfullscreen></iframe>
