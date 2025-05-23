= Restricted Boltzmann Machines

#image("../assets/restricted-boltzmann-machines.png")

== RBM Energy
$E(v, h) = - sum^m_(i=1) sum^n_(j=1) v_i W_(i j) h_j - sum^m_(i=1) b_i v_i - sum^n_(j=1) c_j h_j$ or rewritten $E(v, h) = -v W h^top - b v^top - c h^top$ where $W in RR^(m times n)$ \
Discordance cost: $- v W h^top$. Operating cost: $- b v^top - c h^top$

RBM vs Hopfield: Both find weights that minimize energy, and network converges to low-energy states, but Hopfield sets nodes to target pattern but RBM only visible nodes.

== Energy Gap: (Like gradient but for binary nodes)
$Delta E(v_i) = E(v_i = 1) - E(v_i = 0)$\
$Delta E(v_i) = - sum^n_(j=1) W_(i j)h_j - b_i$, $Delta E(h_j) = - sum^m_(i=1) v_i W_(i j) - c_j$. \
If $Delta E(v_i) > 0$ then turn $v_i$

Networks can get stuck in sub-optimal state $arrow.double$ Use stochastic neurons: \
$P(h_j = 1 | v) = sigma(sum_i v_i W_(i j) + c_j)$, $P(v_i = 1 | h) = sigma(sum_i W_(i j) h_j + b_i)$, $sigma(z) = 1/(1 + e^(-z div T))$ $T$ is temperature

Sampling Algorithm:
- Compute $p_i = P(v_i = 1 | h)$. For $i = 1, dots, m:$
  - Draw $r tilde "Uniform"(0, 1)$. If $p_i > r$ set $v_i = 1$, else set $v_i = 0$

If network run freely, states will all be visited with probability $q(v, h) = 1/Z e^(-E(v, h))$ with partition function $Z = sum_(v, h) e^(-E(v,h))$. Since lower-energy states are visited more frequently, then $E(v^((1)), h^((1))) < E(v^((2)), h^((2))) arrow.r.double q(v^((1)), h^((1))) > q(v^((2)), h^((2)))$

== Generation
Suppose inputs $v tilde p(v)$, we want RBM to act like generative model $q_theta$ such that $max_theta EE_(v tilde p)[ln q_theta(v)]$

Let loss be $L &= - ln q_theta(V) - ln(1/Z sum_h e^(-E_theta(V, h))) \ &= - ln(sum_h e^(-E_theta(V, h))) + ln(sum_v sum_h e^(-E_theta(v, h)))$, which can be decomposed into $L = L_1 + L_2$

$
gradient_theta L_1 &= - gradient_theta (sum_h e^(-E_theta(V, h)))/(sum_h e^(-E_theta(V, h)))
&= sum_h (e^(-E_theta(V, h)))/(sum_h e^(- E_theta(V, h))) gradient_theta E_theta (V, h)
$

Then, since the fraction above is equivalent to $q_theta(h | V)$, we write $gradient_theta L_1 = sum_h q_theta(h | V) gradient_theta E_theta(V, h) = EE_(q(h | V))[gradient_theta E_theta(V, h)]$

$
  gradient_theta L_2 &= - (sum_(v, h) e^(- E_theta) gradient_theta E_theta)/(sum_(v, h) e^(-E_theta)) = - sum_(v, h) q_theta(v, h) gradient_theta E_theta (v, h) \
  &= - EE_(q(v, h))[gradient_theta E_theta(v, h)]
$

$gradient_(W_(i j)) E(V, h) = - V_i h_j$ and $gradient_(W_(i j)) E(v, h) = - v_i h_j$ and thus $gradient_(W_(i j))L = - EE_(q(h | V))[V_i h_j] + EE_(q(v, h))[v_i, h_j]$. \
First term represents expected value under posterior distribution, and second term under joint distribution

== Contrastive Divergence for Training
1. Clamp visible states to $V$ and calculate hidden probabilities $q(h_j | V) = sigma(V W_(, j) + c_j)$ and $gradient_W L_1 = - V^top sigma(V W + c)$ which results in a rank-1 outer product in $RR^(m times n)$

2. Compute expectation using Gibbs sampling. $angle.l v_i h_j angle.r_(q(v, h)) = sum_v sum_h q(v, h) v_i h_j$. Practically, single network state is used to approximate expectation. Gibbs sampling is used to run the network freely and compute average $v_i h_j$, which has $gradient_W L_2 = v^top sigma(v W + c)$. 

Procedure for training: Given $V$ calculate $h$, then given new $h$ calculate $v$, and from new $v$ calculate second $h$. 

Weight update rule is: $W arrow.l W - eta(gradient_W L_1 + gradient_W L_2)$ where $eta$ is learning rate.

== Sampling
#box(
  image("../assets/generator-boltzmann.png", width: 50%)
)
After training, we can generate new $M$ data points $V^((1)), V^((2)), dots V^((M))$ by performing Gibbs sampling from the conditional probabilities $P(v|h)$ as illustrated. 

