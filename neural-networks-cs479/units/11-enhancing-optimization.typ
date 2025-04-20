= Optimization (Better learning rate)
/ Stochastic Gradient Descent: Computing gradient of loss can be expensive for huge dataset. $E(Y, T) = 1/D sum_D L(y_i, t_i)$

Solution: Take random group $gamma$ of $B$ samples. Estimate $E(Y, T) approx E(accent(Y, ~), accent(T, ~)) = 1/B sum_B L(y_(gamma_b), t_(gamma_b))$

Update after each batch $B$, and then continue gathering batches until all of dataset has been sampled to complete epoch.

== Momentum
Use: Gradient descent oscillates often reaching optimum; grad.desc stops at local optimum (not global).
Gradient is a force instead of slope. $theta_(n+1) = theta_n + Delta t v_n$ and $v_(n+1) = (1-r)v_n + Delta t A_n$ where $A_n$ represents the gradient vector, so we make $v^((t)) arrow.l beta v^((t-1)) + gradient_W E$ and $w^((t)) arrow.l w^((t-1)) - eta v^((t))$

We think of $v_n$ as the "velocity" and $A_n$ (gradient vector) is the force. This gives direction and magnitude. If we move in the same direction all the time, then we gather "momentum", and are able to make bigger steps, by increasing velocity.