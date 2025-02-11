= Neural Nets w/w Auto-Diff
== Gradient Descent Pseudocode
- Initialize $v, kappa$
- Make expression graph for $E$
- Until convergence:
  - Evaluate E at $v$
  - Zero-grad
  - Calculate gradients
  - Update $v arrow.l "v" - kappa "v.grad"$
== Neural Learning
Optimizing our weights and biases for our loss function.
$W arrow.l arrow - kappa gradient_W E$
By making network with AD classes, we leverage backward() to optimize gradient computation.

=== Pseudocode
Given Dataset $(X, T)$ and network model *net*, with parameters $theta$ and loss function $L$
- y = *net*(X)
- loss = L(y, T)
- loss.zero_grad()
- loss.backward()
- $theta arrow.l kappa dot theta."grad"$