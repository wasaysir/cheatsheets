= Neurons
Signals travel via axon, from Soma. Dendrites get signals.

Membranes have Na (out->in) and K Channels (in->out) and a Na-K Pump (3 Na in->out for 2K out->in).

/ Membrane Potential: Difference in voltage across membrane. At Rest: -70mV, enforced by Na-K Pump.
/ Action Potential: Electrical impulse travelling along axon to the synapse. 

== Hodgkin-Huxley Model
Model of Neuron based on Ion Channel components.

% of K+ channels open: $n(t)^4$. % of Na+ channels: $h(t)m(t)^3$

Gate dynamic system: $n(t) = (d n)/(d t) = 1/(tau_n(V))(n_infinity(V)-n)$ (Same for all gates: n, h, m)

Membrane Potential Dynamics:
$C (d V)/(d t) = J_(i n) - g_L(V-V_L) - g_(N a)m^3h(V-V_(N a)) - g_K n^4(V-V_k)$

($C$: Membrane capacitance)
($C (d V)/(d t)$: Net current inside cell)
($J_(i n)$: Input current from other Neurons)
($g_L$: Leak conductance (membrane not impenetrable to ions))
($g_(N a)$: Maximum Na conductance)
($g_K$: Maximum K conductance)
($V_L$: Resting potential)

// Process: Stimulus breaks threshold, opening Na+ channels which then close at action potential. Potassium channels open at action potential and close at refractory period. 

== Leaky-Integrate-and-Fire Model
Doesn't model spike shape, only considers sub-threshold voltage and threshold reached.

Dynamics system: $c (d V)/(d t) = J_(i n) - g_L (V - V_L)$ Dimensionless equation is $tau_m (d v)/(d t) = v_(i n) - v$ for $v < 1$

Spike when $v = 1$ with $t_(r e f)$ wait before starting at $0$ again.

Explicit Model: $v(t) = v_(i n)(1 - e^(- t/tau))$ if $v_(i n)$ is constant. $V_(i n) = R J_(i n), tau_m = R C, v = (V - V_L)/(V_(t h) - V_L), v_(i n) = V_(i n)/(V_(t h) - V_L)$

\ Firing Rate: $1/(tau_("ref") - tau_m ln(1 - 1\v_(i n)))$ for $v_(i n) > 1$
\ Tuning Curve: Graph showing how neuron reacts to different input currents.

== Activation Functions (Sigmoidal)
Logistic Curve: $1 / (1 + e^(-z))$ Range(0,1) | $arctan(h)$ Range($-pi/2, pi/2$) | $tanh(z)$ Range($-1, 1$) | Threshold | ReLU | Softplus: $log(1 + e^z)$ Smooth approx of ReLU | SoftMax: $exp(z_i)/(sum_j exp(z_j))$ | ArgMax - Largest to 1, 0 else