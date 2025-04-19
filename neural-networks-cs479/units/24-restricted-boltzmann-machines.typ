= Restricted Boltzmann Machines

#image("../assets/restricted-boltzmann-machines.png")

Network consists of:
- Hidden layer and visible layers (nodes only binary) and connections between layers are symmetric by weight matrix $W$

== RBM Energy
- RBM's energy is $E(v, h) = - sum^m_(i=1) sum^n_(j=1) v_i W_(i j) h_j - sum^m_(i=1) b_i v_i - sum^n_(j=1) c_j h_j$ or rewritten $E(v, h) = -v W h^top - b v^top - c h^top$ where $W in RR^(m times n)$. Discordance cost: $- v W h^top$. Operating cost: $- b v^top - c h^top$

RBM vs Hopfield: Both Find weights that minimize energy, and runninng network converges to low-energy states, but Hopfield sets nodes to target pattern but RBM only visible nodes.

== Energy Gap: (Like gradient but for binary nodes)
$delta E(v_i) = E(v_i = 1) - E(v_i = 0)$, for $i = 1, dots, m: delta E(v_i) = - sum^n_(j=1) W_(i j)h_j - b_i$
For $j = 1, dots, n: delta E(h_j) = - sum^m_(i=1) v_i W_(i j) - c_j$. Then if $delta E(v_i) > 0$ then turn $v_i$ off, meaning $E(v_i = 1) > E(v_i = 0)$

One issue is that these binary networks can get stuck in sub-optimal state, so we can use stochastic neurons as $P(h_j = 1 | v) = sigma(sum_i v_i W_(i j) + c_j)$ (similar for visible nodes) where logistic is defined as $sigma(z) = 1/(1 + e^(-z/T))$, which is temperature dependent.

Sampling Algorithm:
- Compute $p_i = P(v_i = 1 | h)$
- For $i = 1, dots, m:$
  - Draw $r tilde "Uniform"(0, 1)$
  - If $p_i > r$ set $v_i = 1$, else set $v_i = 0$

== Network Dynamics
If we run network freely, then network states will all be visited with probability $q(v, h) = 1/Z e^(-E(v, h))$ where partition function $Z$ is defined as $Z = sum_(v, h) e^(-E(v,h))$. Since lower-energy states are visited more frequently, then $E(v^((1)), h^((1))) < E(v^((2)), h^((2))) arrow.r.double q(v^((1)), h^((1))) > q(v^((2)), h^((2)))$

== Generation
Suppose inputs $v tilde p(v)$, we want RBM to act like generative model $q_theta$ such that $max_theta EE_(v tilde p)[ln q_theta(v)]$

Let loss be $L = - ln q_theta(V)$ for given $V$, or $L = - ln(1/Z sum_h e^(-E_theta(V, h))) = - ln(sum_h e^(-E_theta(V, h))) + ln(sum_v sum_h e^(-E_theta(v, h)))$, which can be decomposed into $L = L_1 + L_2$

== Gradient of $L_1$
- To optimize parameter, we need to compute gradient of loss function:
$
gradient_theta L_1 &= - gradient_theta (sum_h e^(-E_theta(V, h)))/(sum_h e^(-E_theta(V, h))) \
&= (sum_h e^(-E_theta(V, h)) gradient_theta E_theta(V, h))/(sum_h e^(-E_theta(V, h))) \
&= sum_h (e^(-E_theta(V, h)))/(sum_h e^(- E_theta(V, h))) gradient_theta E_theta (V, h) \
$

Then, since the fraction above is equivalent to $q_theta(h | V)$, we write $gradient_theta L_1 = sum_h q_theta(h | V) gradient_theta E_theta(V, h) = EE_(q(h | V))[gradient_theta E_theta(V, h)]$

== Gradient of $L_2$
$
  gradient_theta L_2 &= - (sum_(v, h) e^(- E_theta) gradient_theta E_theta)/(sum_(v, h) e^(-E_theta)) \
  &= - sum_(v, h) q_theta(v, h) gradient_theta E_theta (v, h) \
  &= - EE_(q(v, h))[gradient_theta E_theta(v, h)]
$

Thus $gradient_theta L = gradient_theta L_1 + gradient_theta L_2  = EE_q(h|V)[gradient_theta E_theta] - EE_(q(v, h))[gradient_theta E_theta]$

== Gradient for $W_(i j)$
$gradient_(W_(i j)) E(V, h) = - V_i h_j$ and $gradient_(W_(i j)) E(v, h) = - v_i h_j$ and thus $gradient_(W_(i j))L = - EE_(q(h | V))[V_i h_j] + EE_(q(v, h))[v_i, h_j]$. First term represents expected value under posterior distribution, and second term under joint distribution

== Contrastive Divergence for Training
Step 1: Clamp visible states to $V$ and calculate hidden probabilities $q(h_j | V) = sigma(V W_(, j) + c_j)$ and $gradient_W L_1 = - V^top sigma(V W + c)$ which results in a rank-1 outer product in $RR^(m times n)$

Step 2: Compute expectation using Gibbs sampling. $angle.l v_i h_j angle.r_(q(v, h)) = sum_v sum_h q(v, h) v_i h_j$. Practically, single network state is used to approximate expectation. Gibbs sampling is used to run the network freely and compute average $v_i h_j$, which has $gradient_W L_2 = v^top sigma(v W + c)$. 

Procedure for training: Given $V$ calculate $h$, then given new $h$ calculate $v$, and from new $v$ calculate second $h$. 

Weight update rule is: $W arrow W - eta(gradient_W L_1 + gradient_W L_2) = W + eta V^top sigma(V W + c) - eta v^top sigma(v W + c)$ where $eta$ is learning rate. First term relates to positive phase (step 1) and second term to negative step (step 2).

== Sampling
After training, we can use it as generative model to generate new $M$ data points $V^((1)), V^((2)), dots V^((M))$ by performing Gibbs sampling from the conditional probabilities $P(v|h)$ as illustrated below: 

#image("../assets/generator-boltzmann.png")