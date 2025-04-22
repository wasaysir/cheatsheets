= Dynamics

To build dynamic, recurrent networks via population coding methods, we'll leverage a dynamic model of LIF neurons based on current and activity. Our population coding methods will operate on activity, so we can modify the input current to establish forces on the activity.

$
  tau_s (d s)/(d t) = -s + C "Current" \
  tau_m (d v)/(d t) = -v + sigma(s) "Activity"
$

Equilibrium values are when differential values equal $0$

If $tau_m lt.double tau_s$ then Activity function reaches equilibrium value, while current is still in dynamic state. Same for if $tau_s lt.double tau_m$

#box(
  image("../assets/integrating_dynamics.png", width: 50%)
)
If we're integrating the input, then $tau_s (d s)/(d t) = -s + sigma(s) W + beta + C$ a recurrent network. Then, $(d s) / (d t) = (-s + v W + beta)/(tau_s) + tilde(tau)$ where $tilde(C) = x E$ because it is the re-integrated input, and isn't dependent on time constant. 

#box(
  image("../assets/general_dynamic_system.png", width:50%)
)
Since we have multiple different forms of the dynamic system, we can generalize to $(d y)/(d t) = f(y)$