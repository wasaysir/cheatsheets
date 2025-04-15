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