= Population Coding

The ability to encode data in a shape we want, and break apart a Black-Box NN to separate interpretable NN features that we can place in sequence.

Given activities of a neural network we can reconstruct input based, off of the specific activation values. Since decoding is linear function, this is regression, with MSE loss, so we can optimize for $1/(2P) min_D norm(H d - X)^2_2$, where $H^((i))$ is a row corresponding to activations of hidden layer.

The optimal linear decoding can be solved to be $d^* = (H^top H)^(-1) H^top X$. 

This can be problematic if $H^top H$ is poorly conditioned (almost singular), so instead we add noise to $H$, and get:
$
  norm((H+epsilon)D - T)^2_2 &= norm((H D - T) + epsilon D)^2_2 \
  &= (H D - T)^top (H D - T) + 2 (H D - T)^top (epsilon D) \
  &+ D^top epsilon^T epsilon D
$

Since middle term is usually zero, since $epsilon$ independent of $H D - T$, then if $epsilon^top epsilon approx sigma^2 I$, then it is finally $norm(H D - T)^2_2 + sigma^2 norm(D)^2_2$

We can also expand population coding to reconstruct vectors. We solve the matrix $D^* = arg min_D (norm H D - T)^2_F$ (frobenius norm) and $T$ is a matrix where each row corresponds to a horizontal sample vector input. 