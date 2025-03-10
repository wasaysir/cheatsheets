= Optimization
Goal is to improve learning rate
== Stochastic Gradient Descent
Computing gradient of cost function can be expensive and time-consuming for huge dataset. 

$
  E(Y, T) = 1/D sum^D_(d=1) L(y_d, t_d)
$ (This means your error function would be based on the sum of the losses of all values within the dataset.)

Solution: Take random sample $gamma$ containing $B$ elements from ${1, 2, dots, D}$ (A random sample of the indices of the dataset).

Then, estimate 
$
E(Y, T) approx E(accent(Y, ~), accent(T, ~)) = 1/B sum_(b=1)^B L(y_(gamma_b), t_(gamma_b))
$

/ Batch: ${(y_(gamma_1), t_(gamma_1)), dots, (y_(gamma_B), t_(gamma_B))}$

This estimate is used to update weights, and then we continue gather batches to update weights until all of the dataset has been sampled and then an epoch is complete.

== Momentum
Usecases: When gradient descent oscillates very often before converging to a local minimum; optimization stops at shallow local optimum without global optimum.
Gradient is a force instead of slope. $theta_(n+1) = theta_n + Delta t v_n$ and $v_(n+1) = (1-r)v_n + Delta t A_n$ where $A_n$ represents the gradient vector, so we make $v^((t)) arrow.l beta v^((t-1)) + gradient_W E$ and $w^((t)) arrow.l w^((t-1)) - eta v^((t))$

We think of $v_n$ as the "velocity" and $A_n$ (gradient vector) is the force. This gives direction and magnitude. If we move in the same direction all the time, then we gather "momentum", and are able to make bigger steps, by increasing velocity.