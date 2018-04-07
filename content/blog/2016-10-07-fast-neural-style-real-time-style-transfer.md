---
author: Andrew B. Collier
date: 2016-10-07T15:00:33Z
tags: ["Machine Learning"]
title: 'fast-neural-style: Real-Time Style Transfer'
---

I followed up a reference to [fast-neural-style](https://github.com/jcjohnson/fast-neural-style) from Twitter and spent a glorious hour experimenting with this code. Very cool stuff indeed. It's documented in [Perceptual Losses for Real-Time Style Transfer and Super-Resolution](http://cs.stanford.edu/people/jcjohns/eccv16/) by Justin Johnson, Alexandre Alahi and Fei-Fei Li.

The basic idea is to use feed-forward convolutional neural networks to generate image transformations. The networks are trained using perceptual loss functions and effectively apply style transfer.

What is "style transfer"? You'll see in a moment.

As a test image I've used my Twitter banner, which I've felt for a while was a little bland. It could definitely benefit from additional style.
                
<img src="/img/2016/10/twitter-banner.jpg" width="100%">

What about applying the style of van Gogh's [The Starry Night](https://en.wikipedia.org/wiki/The_Starry_Night)?
                
<img src="/img/2016/10/twitter-banner-1.png" width="100%">

That's pretty cool. A little repetitive, perhaps, but that's probably due to the lack of structure in some areas of the input image.

How about the style of Picasso's [La Muse](https://www.wikiart.org/en/pablo-picasso/a-muse-1935)?
                
<img src="/img/2016/10/twitter-banner-2.png" width="100%">

Again, rather nice, but a little too repetitive for my liking. I can certainly imagine some input images on which this would work well.

Here's another take on La Muse but this time using [instance normalisation](https://arxiv.org/pdf/1607.08022v2.pdf).
                
<img src="/img/2016/10/twitter-banner-6.png" width="100%">

Repetition vanished.

What about using some abstract contemporary art for styling?

<!-- This is produced using candy.t7. -->
                
<img src="/img/2016/10/twitter-banner-4.png" width="100%">

That's rather trippy, but I like it.

Using a mosaic for style creates an interesting effect. You can see how the segments of the mosaic are echoed in the sky.
                
<img src="/img/2016/10/twitter-banner-7.png" width="100%">

Finally using Munch's [The Scream](https://en.wikipedia.org/wiki/The_Scream). The result is dark and forboding and I just love it.
                
<img src="/img/2016/10/twitter-banner-8.png" width="100%">

Maybe it's just my hardware, but these transformations were not quite a "real-time" process. Nevertheless, the results were worth the wait. I certainly now have multiple viable options for an updated Twitter header image.

## Related Projects

If you're interested in these sorts of projects (and, hey, honestly who wouldn't be?) then you might also like these:

* [neural-style-tf](https://github.com/cysmith/neural-style-tf) (a TensorFlow implementation); 
* [Supercharging Style Transfer](https://research.googleblog.com/2016/10/supercharging-style-transfer.html).