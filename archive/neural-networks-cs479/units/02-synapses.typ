= Synapses
Presynaptic action potential releases neurotransmitters across synaptic cleft which binds to postsynaptic receptors, opens ion channels.

Postsynaptic potential filter/Current entering *postsynaptic neuron*:
$h(t) = k t^n e^(-t/tau_s) "if" t gt.eq 0 (n in ZZ_(gt.eq 0))$ 0 otherwise

$k$ is selected so $integral_0^infinity h(t) d t = 1 arrow.double.r display(k = 1/(n! tau_s^(n+1)))$

*Spike train*: Series of multiple spikes $a(t) = sum_(p = 1)^k delta(t - t_p)$

*Dirac function*: Infinite at $t=0$, $0$ everywhere else.
Properties: $integral_(- infinity)^infinity delta(t) d t = 1$, $integral_(-infinity)^infinity f(t) delta(t - tau) d t = f(tau)$

*Filtered Spike Train*: $s(t) = a(t) convolve h(t)$ Essentially, convolve each spike in spike train to the postsynaptic potential filter.

Derivation:
$
  s(t) &= a(t) convolve h(t)
  &= integral sum_p delta(t - t_p) h(t - tau) d tau
  &= sum h_p(t - t_p)
$

/ Neuron Activities: Neurons have multiple connections with different weights represented by $W in R^(N times M)$. Neuron function: $accent(z, arrow) = accent(x, arrow) W + accent(b, arrow)$, and $accent(y, arrow) = sigma(accent(z, arrow))$

/ Bias: Add neuron with constant $1$, with weights: $accent(x, arrow) W + accent(b, arrow) = mat(accent(x, arrow), 1) dot mat(W ; accent(b, arrow))$

/ Connections between spiking neurons: Let $n = 0$ for simplicity in $h(t)$, this solves IVP $tau_s (d s)/(d t) = -s, s(0) = 1/tau_s$

== Full LIF Model
Dynamics are described by:
$display(cases(tau_m (d v_i)/(d t) = s_i - v_i "if not in refractory period", 
tau_s (d s_i)/(d t) = -s_i))$

If $v_i = 1$, start refractory period, send spike, reset $v_i$ to 0. If spike arrives from neuron $j$, then $s_i arrow.l s_i + w_(i j)/tau_s$