= Aliasing

== Oversampling
/ Oversampling: Sampling multiple rays per pixel. This process not just reduces aliasing and produces better images, but it reduces sharp shadows, reflections, and refractions at a bigger computational cost. 

/ Regular Sampling:  Pixel is subdivided into regions and one sample is placed at the center of each of these regions. This has low computational cost, but regular error (we have a grid-like structure that can cause jagged lines and aliasing)
/ Random Sampling: Samples are randomly selected within pixel. This leads to less regularity within error, but can cause clumping.
/ Jittering: Pixel is subdivided into regions and one sample is randomly placed in each of those regions. This leads to less regularity and less clumping, better images but it's expensive.