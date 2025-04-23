= Optimization (Better learning rate)
/ Stochastic Gradient Descent: Computing gradient of loss can be expensive for huge dataset. $E(Y, T) = 1/D sum_D L(y_i, t_i)$

Solution: Take random group $gamma$ of $B$ samples. Estimate $E(Y, T) approx E(accent(Y, ~), accent(T, ~)) = 1/B sum_B L(y_(gamma_b), t_(gamma_b))$

Update after each batch $B$, and each epoch is gathering batches until entire dataset has been sampled.

== Momentum
Use: Gradient descent oscillates often reaching optimum; grad.desc stops at local optimum.
Gradient is a force instead of slope. $theta_(n+1) = theta_n + Delta t v_n$ and $v_(n+1) = (1-r)v_n + Delta t A_n$ where $A_n$ represents the gradient vector, so we make $v^((t)) arrow.l beta v^((t-1)) + gradient_W E$ and $w^((t)) arrow.l w^((t-1)) - eta v^((t))$

$v_n$ is "velocity" and $A_n$ (gradient vector) is force, with direction and magnitude. By move in same direction, we gather "momentum", and increase velocity, taking bigger steps.