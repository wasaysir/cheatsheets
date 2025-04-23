= Hopfield Networks
/ Hopfield Network: Given a network of $N$ neurons (each connected to all others) a set of $M$ possible targets, we want the network to converge to the nearest target.

$x_i = -1 "if" accent(x, arrow)W + b_i < 0$, otherwise $1$

Goal: Min Hopfield Energy w/w grad.desc, instead of backprop (cycles).

$E = - 1/2 sum_i sum_(j eq.not i) x_i W_(i j) x_j - sum_i b_i x_i = - 1/2 accent(x, arrow) W accent(x, arrow)^T - overline(b) accent(x, arrow)^T$, $W_(i i) = 0$

$(partial E)/(partial x_j) = - sum_(i eq.not j) x_i W_(i j) - b_j$

$nabla_(accent(x, arrow)) E = - accent(x, arrow) W - overline(b) arrow.double tau_x (d accent(x, arrow))/(d t) = accent(x, arrow) W + overline(b)$

If $i eq.not j$, $(partial E)/(partial W_(i j)) = - x_i x_j$ and if $i = j$ $(partial E)/(partial W_(i i)) = - x_i^2 = -1$

Gradient vector is $nabla_W E = - accent(x, arrow)^T accent(x, arrow) + I_(N times N)$

$nabla_W E = -1/M sum^M_(s=1) (arrow(x)^((s)))^T arrow(x)^((s)) + I = -1/M X^T X + I$

Thus $tau_w (d W)/(d t) = 1/M X^T X - I$ $X^T X$ is coactivation states b/w neuron pairs.