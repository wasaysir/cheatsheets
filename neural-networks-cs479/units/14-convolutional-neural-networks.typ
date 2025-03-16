= Convolutional Neural Networks

\ Convolution: A mathematical operation that combines two functions by sliding them against each other. Essentially, you create a window, where each element in the window is a function, then you transform the original function over the window to get a frankenstein function.

\ Continuous Convolution: $(f convolve g)(x) = integral_(- infinity)^(infinity) f(s) dot g(x-s) d s$

\ Discrete Convolution: $(f convolve g)_m = sum^(N-1)_(n=0) f_n dot g_(m-n)$

Convolution in 2D: 
$(f convolve g)_(m, n) = sum_(i j) f_(i j) dot g_(m-i, n-j)$
$(f ast.circle g)_(m, n) = sum_(i j) f_(i j) dot g_(i-m, j-n)$

Each kernel is convolved against the layer before it, creating an activation map, which creates a tensor for the next layer. We can have multiple kernels per input layer. 

\ Stride: The amount the kernel is shifted against the input layer.

\ Padding: Padding border of input layer with 0s to create a layer that is identical size as layer. 

*Note*: The bias is attributed to the kernel as a hole, rather than the neurons in the kernel.

*Note*: 1x1 convolution layers make sense when the input layers have many layers, in which case you can create a kernel against many of the features of the pixel. (Ex 1x1x64)