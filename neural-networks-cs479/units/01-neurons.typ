= Neurons
Signals travel via axon, from Soma. Dendrites get signals.

Membranes have Na (pump out) and K Channels (pump in) and a Na-K Pump (3 Na out for 2K in).

/ Membrane Potential: Difference in voltage across membrane. At rest, value is -70mV, enforced by Na-K Pump.
/ Action Potential: Electrical impulse travelling along axon to the synapse. 

== Hodgkin-Huxley Model
Model of Neuron based on Ion Channel components.

// n(t)^4 because there are 4 identical gates for Potassium
// h(t) m(t)^3 because there are 3 identical gates for Sodium, and one unique one.
Fraction K+ channels open: $n(t)^4$. Na+ channels: $h(t)m(t)^3$

Gate dynamic system: $a(t) = (d a)/(d t) = 1/(tau_a(V))(a_infinity(V)-a)$ (For all gates-Replace a, with n, h, t)

Membrane Potential Dynamics:
$c (d V)/(d t) = J_(i n) - g_L(V-V_L) - g_(N a)m^3h(V-V_(N a)) - g_K n^4(V-V_k)$
$c$: Membrane capacitance
$I = C (d V)/(d t)$: Net current inside cell
$J_(i n)$: Input current from other Neurons
$g_L$: Leak conductance (membrane not impenetrable to ions)
$g_(N a)$: Maximum Na conductance
$g_K$: Maximum K conductance

Action Potential form:
#box(
  image("../assets/spike.png", width: 30%),
)

Process: Stimulus breaks threshold causing Na+ channels to open, then close at action potential. Potassium channels open at action potential and close at refractory period. 

== Leaky-Integrate-and-Fire Model
Spike shape is constant over time, more important to know when spiked than shape. LIF only considers sub-threshold voltage and when peaked.

Dynamics system: $c (d V)/(d t) = J_(i n) - g_L(V - V_L) arrow.r.double tau_m (d V)/(d t) = V_(i n) - (V - V_L)$ for $V < V_(t h)$

This is dimensioned. Dimensionless converts $v_(i n) = (v_(i n))/(v_(t h) - V_L)$ to become $tau_m (d v)/(d t) = v_(i n) - v$

Then spike occurs when $v = 1$ and we set a refractory period of $t_(r e f)$ before starting at $0$ again.

Explicit Model: $v(t) = v_(i n)(1 - e^(- t/tau))$

*Firing Rate*: $1/(tau_("ref") - tau_m ln(1 - 1\v_in))$ for $v_(in) > 1$
*Tuning Curve*: Graph showing how neuron reacts to different input currents.

== Activation Functions (Sigmoidal)
Logistic Curve: $1 / (1 + e^(-z))$, $arctan(h)$, $tanh(z)$, threshold, ReLU, Softplus: $log(1 + e^z)$, SoftMax: $exp(z_i)/(sum_j exp(z_j))$, ArgMax