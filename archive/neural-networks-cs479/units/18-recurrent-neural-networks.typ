= Recurrent Neural Networks
Hidden layer encodes input sequence, for modeling sequential data.
/ Backprop Through Time: Unroll network through time, to create feedforward network into a DAG, and evaluate the targets in sequence similar to how you would batch inputs.

Note: $h^i = f(x^i U + h^(i-1) W + b)$, $y^i = "Softmax"(h^i V + c)$ \
$U$: Input->Hidden. $W$: Hidden->Hidden $V$ Hidden->Output
Error function is: $E(y_1, dots, y_t, t_1, dots, t_t) = sum_(i=1)^T L(y_i, t_t) alpha_i$ \
The goal is to minimize the following: $min_theta EE[E(y_1, dots, y_t, t_1, dots, t_t)]_(y, t)$ \
Objective: $theta^* = arg min_theta EE_((x, t) in D) cal(L)(y, t)$, $theta = {U, V, W, b, c}$

Deep RNN: Multiple Hidden layers per timestep. Each layer processes, then passes to next. Deep RNNS reduce cost compared to increasing hidden state size, and has better representation learning.