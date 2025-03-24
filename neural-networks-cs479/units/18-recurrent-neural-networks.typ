= Recurrent Neural Networks

Hidden layer can encode input sequence, allowing sequential data to be outputted.

\ Backprop Through Time: Unroll network through time, to create feedforward network into a DAG, and evaluate the targets in sequence similar to how you would batch inputs.

Note: $h^i = sigma(x^i U + h^(i-1) W + b)$
$y = sigma(h^i V + c)$

The error function is: $E(y_1, dots, y_t, t_1, dots, t_t) = sum_(i=1)^T L(y_i, t_t) alpha_i$

The goal is to minimize the following: $min_theta EE[E(y_1, dots, y_t, t_1, dots, t_t)]_(y, t)$

Following gradients:
$gradient_(z^k) E = gradient_(z^k) (sum^t_(i=1) L(y^i, t^i)) = sum^t_(i=1) gradient_(z^k) L(y^i, t^i) = gradient_(z^k) L(y^k, t^k) = gradient_(y^k) L(y^k, t^k) dot.circle sigma'(z^i)$

$gradient_V E = sum_(i=1)^T h^i gradient_(z^k) L(y^i, t^i)$

In order to derive hidden layer gradients, define $E^k = sum_(i=k)^T L(y^i, t^i)$

Since $h_k$ only affects $h_m$ where $m gt.eq k$ then $gradient_(h^k) E = nabla_(h^k) E^k$

$gradient_(h_tau) E = gradient_(z^tau) E^tau (partial z^tau)/(partial h^tau) = gradient_(z^tau) E^tau) V^T$

Then, we can compute $gradient_(h^i) E$ recursively.

$gradient_(h^i) E = (gradient_(h^(i+1)) E^(i+1) dot.circle sigma'(s^(i+1))) W^T + (gradient_(y^i) L(y^i, t^i) dot.circle sigma'(z^i)) V^T$

Once you have $gradient_(h^i) E$ you can compute gradient with respect to deeper weights and biases recursively.