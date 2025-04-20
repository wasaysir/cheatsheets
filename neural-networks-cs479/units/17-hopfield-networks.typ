= Hopfield Networks
/ Content-Addressable Memory: System that can take part of a pattern and fill in the most likely matches from memory.
/ Hopfield Network: Given a network of $N$ neurons, each connected to all others, and given a set of $M$ possible targets, we want the network to converge to the nearest of this set.

#image("../assets/hopfieldNetwork.png", width: 30%)

Each $x_i$ is assigned: $-1 "if" accent(x, arrow)W + b_i < 0$ and $1 "if" accent(x, W)W + b_i gt.eq$

Since the graph has cycles, backpropagation won't work. Instead we need to utilize the Hopfield Energy:

$E = - 1/2 sum_i sum_(j eq.not i) x_i W_(i j) x_j - sum_i b_i x_i = - 1/2 accent(x, arrow) W accent(x, arrow)^T - overline(b) accent(x, arrow)^T$

and diagonals of $W$ are 0.

To minimize energy, we use gradient descent:
$(partial E)/(partial x_j) = - sum_(i eq.not j) x_i W_(i j) - b_j$ or $nabla_(accent(x, arrow)) E = - accent(x, arrow) W - overline(b) arrow.double tau_x (d accent(x, arrow))/(d t) = accent(x, arrow) W + overline(b)$

If $i eq.not j$, $(partial E)/(partial W_(i j)) = - x_i x_j$

If $i = j$ $(partial E)/(partial W_(i i)) = - x_i^2 = -1$

Therefore gradient vector is $nabla_W E = - accent(x, arrow)^T accent(x, arrow) + I_(N times N)$

Over $M$ targets we have: $nabla_W E = -1/M sum^M_(s=1) (accent(x, arrow)^((s)))^T accent(x, arrow)^((s)) + I = -1/M X^T X + I$

Thus $tau_w (d W)/(d t) = 1/M X^T X - I$