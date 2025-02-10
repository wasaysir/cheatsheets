= Synapses
In real neuron, *Presynaptic action potential* releases *neurotransmitters* across *synaptic cleft* which binds to *postsynaptic* receptors

Equation for current entering *postsynaptic neuron*:
$h(t) = cases(
  k t^n e^(-t/tau_s) "if" t gt.eq 0 ("for some" n in ZZ_(gt.eq 0)),
  0 "if" t < 0
)$

$k$ is selected so $integral_0^infinity h(t) d t = 1 arrow.double.r k = 1/(n! tau_s^(n+1))$

*Postsynaptic potential filter*: $h(t)$

*Spike train*: Series of multiple spikes $a(t) = sum_(p = 1)^k delta(t - t_p)$

*Dirac function*: Infinite at $t=0$, $0$ everywhere else.
Properties: $integral_(- infinity)^infinity delta(t) d t = 1$, $integral_(-infinity)^infinity f(t) delta(t - tau) d t = f(tau)$

*Filtered Spike Train*: $s(t) = a(t) convolve h(t)$ For each spike in spike train, run the postsynaptic potential filter on it, then sum each spike. Essentially, convolve the spike train to the postsynaptic potential filter.

Derivation:
$
  s(t) &= a(t) convolve h(t)
  &= integral sum_p delta(t - t_p) h(t - tau) d tau
  &= sum h(t - t_p)
$

== Neuron Activities
Neurons have multiple connections, with different strengths (weights).
We can represent weights between neuron layers via weight matrix:
$W in R^(N times M)$

Compute neuron function as: $accent(z, arrow) = accent(x, arrow) W + accent(b, arrow)$, thus $accent(y, arrow) = sigma(accent(z, arrow))$

=== Bias Representation
Add a neuron with constant value $1$ for each layer, and use its weights as biases. 

$accent(x, arrow) W + accent(b, arrow) = mat(accent(x, arrow), 1) dot mat(W ; accent(b, arrow))$

=== Connections between spiking Neurons
Let $n = 0$ for simplicity for $h(t)$, then it is a solution of $tau_s (d s)/(d t) = -s, s(0) = 1/tau_s$

== Full LIF Model
Dynamics are described by:
$cases(tau_m (d v_i)/(d t) = s_i - v_i "if not in refractory period", 
tau_s (d s_i)/(d t) = -s_i)$

If $v_i$ reaches 1, then start refractory period, send spike, reset $v_i$ to 0. If spike arrives from neuron $j$, then $s_i arrow.l s_i + w_(i j)/tau_s$