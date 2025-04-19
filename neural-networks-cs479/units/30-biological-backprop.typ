= Biological Backprop

In neurons, updates can only use local information, but backpropagation updates to weights involves various layers of information.

== Predictive Coding (PC)
- Predictions are sent down the hierarchy
- Errors are sent up the hierarchy
#image("../assets/predictive-coding.png")

In a PC-Node, there are two parts: Value/State Node and an error node.

#image("../assets/predictive-coding-node.png")

$mu^i = sigma((x^(i+1))M^i + beta^i)$, this is our prediction.
For simplicity, assume $W^i = (M^i)^T$

=== Error Node
$tau (d epsilon^i)/(d t) = x^i - mu^i - v^i_"leak" e^i$, which at equilibrium reaches $epsilon^i = 1/(v^i)(x^i - mu^i)$

=== Generative Network
Given dataset $x, y$ and $theta = {M^i, W^i}_(i=1, dots, L-1)$, the goal is to $max_theta EE_((x,y))[log p(x | y)]$
$p(x | y) = p(x^1 | x^2) p(x^2 | x^3) dots p(x^(L-1) | y) = p(x^1 | mu^1) dots p(x^(L-1) | mu^(L-1))$

If we assume $x^i tilde cal(N)(mu^i, v^i)$, then $p(x^i | mu^i) prop exp(- (norm(x^i - mu^i)^2)/(2(v^i)^2))$
Then, $- log p(x^i | mu^i) = 1/2 norm((x^i - mu^i)/v^i)^2 + C$, so as a result. $- log p(x | y) = 1/2 sum^(L-1)_(i=1) norm(epsilon^i)^2$

=== Hopfield Energy
$F = 1/2 sum^(L-1)_(i=1) norm(epsilon^i)^2$
$tau (d x^i)/(d t) = - gradient_(x^i) F$

$x^i$ shows up in two terms in $F$: $epsilon^i = x^i - mu^i(x^(i+1)) = x^i - (sigma(x^(i+1))M^i + beta^i)$ and $epsilon^(i-1) = x^(i-1) - mu^(i-1)(x^i) = x^(i-1) - (sigma(x^i)W^(i-1) + beta^(i-1))$

Therefore $gradient_(x^i) F = epsilon^i (partial epsilon^i)/(partial x^i) + epsilon^(i-1) (partial epsilon^i-1)/(partial x^i) = epsilon^i - sigma prime (x^i) dot.circle (epsilon^(i-1)(W^(i-1))^T)$

=== Dynamics
$tau (d x^i)/(d t) = sigma prime(x^i) dot.circle (epsilon^(i-1)M^i) - epsilon^i$ and $tau (d epsilon^i)/(d t) = x^i - mu^i - v^i epsilon^i$. Then learning $M^i$ involves $gradient_(M^i)F = - (sigma(x^(i+1)))^T epsilon^i$ with systems $(d M^i)/(d t) = sigma(x^(i+1)^T) epsilon^i$ and $tau (d W^i)/(d t) = (epsilon^i)^T dot sigma(x^(i+1))$. 

At equilibrium we get $epsilon^i = sigma prime(x^i) dot.circle [epsilon^(i-1)(W^(i-1)^T)]$ where $(partial F)/(partial mu^i) = - epsilon^i$

Training: Clamp $x^1 = X$ and $x^L = Y$ and run to equilibrium. $x^i, epsilon^i$ reach equilibrium quickly. Then use the two systems based on $d M^i$ and $d W^i$ to update $M^i$ and $W^i$

Generating: Clamp $x^L = Y$ and run to equilibrium and $x^1$ is a generated sample

Inference: Clamp $x^1 = X$ run to equilibrium and $arg max_j (x^L_j)$ is the class

This work overcomes the local learning condition because running to equilibrium allows information to spread through the net.