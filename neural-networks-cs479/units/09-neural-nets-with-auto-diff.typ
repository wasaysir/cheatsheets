= Neural Nets w/w Auto-Diff
== Neural Learning
Optimizing our weights and biases for our loss function.
$W arrow.l W - kappa gradient_W E$
By making network with AD classes, we leverage backward() to optimize gradient computation.

=== Pseudocode
Given Dataset $(X, T)$ and network model *net*, with parameters $theta$ and loss function $L$
- y = *net*(X)
- loss = L(y, T)
- loss.zero_grad()
- loss.backward()
- $theta arrow.l kappa dot theta."grad"$