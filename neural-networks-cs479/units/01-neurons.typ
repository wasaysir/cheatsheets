= Neurons

#let definitions(dict) = {
  let terms = dict.keys()
  let defs = dict.values()
  let entries = terms.zip(defs)
  
  let words = entries.map(y => y.map(x => [#x])).join()
  
  table(
    columns: 2,
    ..words
  )
}

== Biology
Neuron contains *Soma, Axon, Dendrites*. Signals travel away from Soma via Axon.

=== Membrane
Membranes contain Sodium and Potassium Channels and a Sodium-Potassium Pump.
Each Channel:
1. Na: Outside of cell
2. K: Inside of cell
3. Na-K Pump: 3 Sodium out for 2 Potassium in

*Voltage Difference (Membrane Potential)*: Difference in voltage on either side of membrane. Resting potential is -70mV. This resting potential is enforced by the Na-K Pump.

*Action Potential*: Electrical impulse travelling along axon to the synapse. 

== Hodgkin-Huxley Model
Model of Neuron based on Ion Channel components.

Fraction of K+ channels open is $n(t)^4$. There are four identical gates in K+ channel.
Fraction of Na+ channels open is $h(t)m^(t)^3$. There are three identical gates and one unique gate in Na+ channel.

Gate dynamic system is a(t): $(d a)/(d t) = 1/(tau_a(V))(a_infinity(V)-a)$

Membrane Potential Dynamics:
$c (d V)/(d t) = J_(i n) - g_L(V-V_L) - g_(N a)m^3h(V-V_(N a)) - g_K n^4(V-V_k)$
$c$: Membrane capacitance
$I = C (d V)/(d t)$: Net current inside cell
$J_(i n)$: Input current from other Neurons
$g_L$: Leak conductance (membrane not impenetrable to ions)
$g_(N a)$: Maximum Na conductance
$g_K$: Maximum K conductance

Action Potential form:
#figure(
  image("../assets/image.png", width: 30%),
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
Logistic Curve: $1 / (1 + e^(-z))$
Arctan: $arctan(z)$
Hyperbolic Tangent: $tanh(z)$
Threshold: $0 "if" z lt 0; 1 "if" z gt.eq 0$
Rectified Linear Unit: $max(0, z)$
Softplus: $log(1 + e^z)$

=== Multi-Neuron Activation Functions
SoftMax: $exp(z_i)/(sum_j exp(z_j))$ Converts elements to probability distribution (sum to 1) and normalizes values
ArgMax: Largest element remains nonzero, everything else $0$