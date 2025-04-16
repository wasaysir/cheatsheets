= Machine Learning

== Bayesian Learning
Premise is we have multiple hypotheses without knowing which is correct; we assume all are correct to a degree, and have a distribution over models with the goal of computing expected prediction given average.

Suppose $X$ is input features, and $Y$ is target feature, $d = {x_1, y_1, dots, x_N, y_N}$ as evidence and we want to know, summing over all models, $m in M$:
$P(Y | x, d) = sum_(m in M) P(Y, m | x, d) = sum_(m in M) P(Y | m, x) P(m | d)$

\ Bayesian Learning: Given prior $P(H)$, likelihood $P(d | H)$ and evidence $d$, then $P(H | d) prop P(d | H) P(H)$

To predict $X$, we use $P(X | d) = sum_i P(X | d, h_i)P(h_i | D) = sum_i P(X|h_i)P(h_i | d)$ where predictions are weighted averages of predictions of individual hypotheses.

Bayesian Learning Properties:
- Optimal: Given prior, no other prediction is correct more often than Bayesian one
- No overfitting: Prior/likelihood both penalize complex hypohteses

Downsides:
- Bayesian learning can be intractable when hypothesis space is large
- Summing over hypotheses space may be intractable.

== Maximum A Posteriori
Making prediction based on most probable hypothesis: $h_(M A P) = arg max_h_i P(h_i | d)$, $P(X | d) approx P(X | h_(M A P))$, this is in comparison to Bayesian Learning, where all hypotheses are used.

Maximum a posteriori properties:
- Less accurate than Full Bayesian because of only one hypothesis
- MAP and Bayesian converge as data increases
- No overfitting
- Finding $h_(M A P)$ may be intractable, $h_(M A P) = arg max_h P(h | D) = arg max_h P(h) P(d | h) = arg max_h P(h) product_i P(d_i | h)$ which induces non-linear optimization, but we can take log to linearize.

== Maximum Likelihood
Simplify MAP by assuming uniform prior, to get $h_(M L) = arg max_h P(d | h)$, then $P(X | d) approx P(X | h_(M L))$

Maximum Likelihood Properties:
- Less accurate than Bayesian or Maximum A Posteriori since it ignores prior and relies on one hypothesis
- Converges with Bayesian as data amount increases
- More susceptible to overfitting due to no prior
- $h_(M L)$ is easier to find than $h_(M A P)$, $h_(M L) = arg max_h sum_i log P(d_I | h)$

== Binomial Distribution
$binom(n+k, k) theta^n (1-theta)^k$
\ Beta distribution: $B(theta; a, b) prop theta^(a-1) (1-theta)^(b-1)$

== Bayesian Classifier
If you knew classifier you could predict values of features
$P("Class" | X_1, dots, X_n) prop P(X_1, dots, X_n | "Class") P("Class")$

\ Naive Bayesian Classifier: $X_i$ are independent of each other given class, requires $P("Class")$ and $P(X_i | "Class")$ for each $X_i$, so $P("Class"|X_1, dots, X_n) prop product_i P(X_i | "Class") P("Class")$

=== Laplace Correction
If feature never occurs in training set, but it does in test set, Maximum Likelihood may assign zero probability to high likelihood class. The solution is to add 1 to numerator, and add $d$ (arity of variable) to denominator, like a pseudocount.

\ Bayesian Network Parameter Learning: For fully observed data, set $theta_(V, p a(V) = v)$ to relative frequency of values of $V$ given values $v$ of parents of $V$, where these theta values are the parameters, and essentially calculates probability of value $v$ set to $v_i$ given the set values of the parents of $v$

\ Occam's Razor: Simplicity is encouraged in likelihood function; a more complex, high bias function is less preferred, since low-bias can explain more datasets, but with lower probability (higher variance)

\ Bias-Variance Tradeoff: Simple models have high bias, but low variance. Complex models have low bias, but high variance.

== Neural Networks

=== Linear Regression
Model where output is linear function of input features, $hat(Y)_arrow(w)(e) = sum^n_(i=0) w_i X_i (e)$, with $w_0$ as bias term.

SSE is $sum_(e_in E) (Y(e) - hat(Y)_(arrow(w))(e))^2$, to minimize.

Deriving Weights:
- Analytically:
    - Take $arrow(y)$ as vector of output features for $M$ examples.
    - $X$ is matrix where $j^"th"$ column is values of input feature for $j^"th"$ example
    - $arrow(w)$ is vector of weights
    - $arrow(y) = arrow(w) X$, so $arrow(y) X^top (X X^top)^(-1) = arrow(w)$ $(X X^top)^(-1)$ is pseudo-inverse, which we can compute because $X X^top$ is invertible, since it's square.
- Iteratively (not just linear):
    - Using gradient descent for $w_i arrow.l w_i - mu (partial "Error")/(partial w_i)$
    - For SSE, update rule is $w_i arrow.l w_i + mu sum_(e in E)(Y(e) - sum^n_(i=0) w_i X_i (e)) X_i (e)$

\ Stochastic Gradient Descent: Examples are chosen randomly
\ Batched Gradient Descent: Process batch of size $n$ before updating weights. (If $n$ is all data, that's gradient descent, if $n=1$ that's incremental gradient descent)
\ Incremental Gradient Descent: Weight udpates are done immediately after example, but it might "undo" work of other weight updates, creating an oscillation

=== Linear Classifier
\ Squashed Linear function: $hat(Y)_(arrow(w))(e) = f(sum^n_(i=0) w_i X_i (e))$, $f$ is activation function.
Generally, if activation function is differentiable, you can use gradient descent to update weights.

\ Sigmoid: $f(x) = 1/(1 + e^(-x))$ and $f'(x) = f(x)(1-f(x))$

=== Neural Networks
- Can learn same things decision tree can
- Imposes different learning biases
- Back-propagation learning: errors made are propagated

Neural nets have nodes with weights and a bias, receiving inputs that are either example features or outputs of another layer, and output goes through a non-linear activation function (because otherwise you could represent it all linearly)

Common Activation Functions:
- Step Function: Not differentiable (1 for x > 0; 0 else)
- Sigmoid: 
    - For extreme $x$, very close to boundaries 
    - $f(x) = 1/(1+e^(-k x))$ 
    - Can tune sigmoid to step function by changing $k$
    - Vanishing gradients where $f(x)$ changes little at extreme $x$
    - Expensive compared to ReLU
- ReLU:
    - $f(x) = max(0 x)$
    - Differentiable
    - Dying ReLU problem, where inputs approaching $0$ or negative have $0$ gradients, so network can't learn.
- Leaky ReLU: $f(x) = max(0, x) + k dot min(0, x)$
    - Small positive slope $k$ in negative area, enabling learning for negative input values.

\ Feedforward Network: Directed acyclic graph with single direction connections; (Function of inputs)
\ Recurrent Network: Feeds outputs into inputs; Can have short-term memory.

=== Backpropagation
$gradient_(z^((l+1))) E = (partial E)/(partial z^((l+1)))$
$h^((l+1)) = sigma(z^((l+1))) = sigma(W^((l))h^((l)) + b^((l+1)))$ Basically, $h$ is hidden layer, $z$ is input current, $W$ is weight matrix, $b$ is bias. 
$gradient_(z^((l))) E = (d h^((l)))/(d z^((l))) dot.circle [gradient_(z^((l+1)) E dot (W^((l))^T))]$ $dot.circle$ is hadamard product, which does element by element multiplication. We transpose because $W_(i j)$ is connection from $i"th"$ node in $l$ to $j"th"$ node in $l+1$ 

Note that $accent(a, arrow) = accent(x, arrow) W$ in this diagram: #figure(
  image("../assets/neuralNet.png", width: 30%),
)

$(partial E)/(partial W_(i j)^((l)) = (partial E)/(partial z_j^((l+1))) dot (partial z_j^((l+1)))/(partial W_(i j)^((l))) = (partial E)/(partial z_j^((l+1))) dot h_i^((l))$

Finally, 
$gradient_(z^((l)))E = sigma'(z^((l))) dot.circle (gradient_(z^((l+1))) E dot (W^((l)))^T)$
$gradient_(W^((l))) E = [h^((l))]^T gradient_(z^((l+1))) E$

==== Vectorization
We can generalize this process to take a batch of samples by letting $x$ be a matrix of samples instead of just one sample. Then, note $gradient_(z^((l))) E$ is a matrix with same dimension as $z^((l))$ as desired. Further, note that $gradient_(W^((l))) E$ is a gradient vector that sums the weight gradient matrix from each sample.

=== Improving Optimization
\ Momentum: Weight changes accumulate over iterations
\ RMS-Prop: Rolling average of square of gradient
\ Adam: Combination of Momentum and RMS-Prop
\ Initialization: Randomly set parameters to start

=== Improving Generalization: Regularization
- Parameter Norm Penalties added to loss function
- Dataset augmentation
- Early stopping
- Dropout
- Parameter tying
    - Convolutional Neural Nets: Used for images, parameters tied across space
    - Recurrent neural nets: Used for sequences, parameters tied across time

=== Sequence Modelling
- Word Embeddings: Latent vector spaces representing meaning of words in context
- RNNs: Neural net repeats over time and has inputs from previous time step
- LSTM: RNN with longer-term memory
- Attention: Uses expected embeddings to focus updates on relevant parts of network
- Transformers: Multiple attention mechanisms
- LLMs: Very large transformers for language

=== Composite Models
- Random Forests
    - Each decision tree in forest is different
    - Different features, splitting criteria, training sets
    - Average of majority vote determines output
- Support Vector Machines
    - Find classificaiton boundary with widest margin
    - Combined with kernel trick
- Ensemble learning: Combination of base-level algorithms
- Boosting: 
    - Sequence of learners fitting examples the previous learner did not fit well
    - Learners progressively biased towards higher precision
    - Early learners: Lots of false positives, but reject all clear negatives
    - Later learners: Problem is more difficult, but set of examples is more focused around challenging boundary

== Unsupervised Machine Learning

When data is incomplete (missing some variables), or values of some attributes are missing, etc.

=== Maxmium Likelihood Learning
$theta_(V="true", "parents"(V) = v) = P(V = "true" | "parents"(V) = v)$

ML learning of $theta$ is $theta_(V="true", "parents"(V) = v) = ("number with " (V = "true" and "parents"(V) = v))/("number with parents"(V) = v)$

\ Direct maximum likelihood: $h_(M L) = arg max[sum_Z P(e, Z | h)] = dots = arg max_h[log_sum_Z pi^n_(i=1) P(X_i | "parents"(X_i), h)_(E = e)]$

=== Missing Data
You can't ingore missing data unless you know it is missing at random. (If it is, then you can ignore hidden variables, or data with missing variables, but not with true latent variables that are always missing)

Sometimes data is missing because of a correlated variable of interest, which is when you'd need to model why the data is missing.

=== Expectation-Maximization
- Repeat
    - Expectation: based on $h_(M L)$ calculate $P(Z | h_(M L), e)$
    - Maximization: based on expected missing values, compute new estimate of $h_(M L)$

Simple-version: K-means algorithm: Compute most likely k-means, then maximize based on those classifications.