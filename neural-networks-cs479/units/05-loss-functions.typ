= Loss functions

Single Error: $L(y, t)$ is error between one output $y$ and target $t$
Dataset Error: $EE = 1/N sum^N_(i=1) L(y_i, t_i)$ as average error over entire dataset.

== Mean Squared Error
Single Error: $L(y, t) = 1/2 norm(y - t)^2_2$
Activation Function: Linear activation functions (ReLU)
Problems: linear regression problems.

== Bernoulli Cross Entropy
Single Error: $L(y, t) = -log(P(y, t)) = -log(t^y (1-y)^(1-t)) = -(t log(y) + (1-t) log(1-y))$
Activation Function: Logistic function
Problems: Output values are in range $[0, 1]$; 

== Categorical Cross Entropy
Single Error: $L(y, t) = -log(P(x \in C_k, t)) = -log(product^K_(k=1) (y^k)^(t^k)) = - sum^k_(k=1) t^k log(y^k)$
Activation Function: Softmax
Problems: Classification problems with one-hot vectors