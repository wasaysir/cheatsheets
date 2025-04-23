= Convolutional Neural Networks
/ Convolution: Operation that combines two functions by sliding them against each other.
/ Continuous Convolution: $(f convolve g)(x) = integral_(- infinity)^(infinity) f(s) dot g(x-s) d s$
/ Discrete Convolution: $(f convolve g)_m = sum^(N-1)_(n=0) f_n dot g_(m-n)$
Convolution in 2D: 
$(f convolve g)_(m, n) = sum_(i j) f_(i j) dot g_(m-i, n-j)$
$(f ast.circle g)_(m, n) = sum_(i j) f_(i j) dot g_(i-m, j-n)$

Each kernel is convolved against the layer before it, creating an activation map, creating a tensor for the next layer. We can have multiple kernels per input layer. 

*Note*: The bias is attributed to the kernel as a hole, rather than the neurons in the kernel. 1x1 convolution layers are useful in multi-layered input. (Ex 1x1x64)