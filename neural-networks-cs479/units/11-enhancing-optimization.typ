= Optimization
== Stochastic Gradient Descent
Take random batch of samples, then take the expected value over all of them: $E(accent(y, tilde), accent(tau, tilde)) = 1/B sum^B_(d=1)(y_(gamma_d), t_(gamma_d))$

== Momentum
Usecases: When gradient descent oscillates very often before converging to a local minimum; optimization stops at shallow local optimum without global optimum.
Gradient is a force instead of slope. $theta_(n+1) = theta_n + Delta t v_n$ and $v_(n+1) = (1-r)v_n + Delta t A_n$ where $A_n$ represents the gradient vector, so we make $v^((t)) arrow.l beta v^((t-1)) + gradient_W E$ and $w^((t)) arrow.l w^((t-1)) - eta v^((t))$