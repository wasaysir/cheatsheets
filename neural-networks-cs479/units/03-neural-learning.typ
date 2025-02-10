= Neural Learning
== Supervised Learning
Desired output is known, and we can minimize error within our model's predictions

*Regression*: Output is continuous-based function of inputs, goal is to get closest to output function.

*Classification*: Outputs are in discrete categories. 

== Unsupervised Learning
Output is not known, so goal is to find efficient structure of input
== Reinforcement Learning
Feedback is given, but it's uninformative, and depends on lots of variables (ex. Chess AI)

== Optimization
Given neural model, goal is to optimize weights to minimize loss function.

$min_theta EE_((x, t) in "data") [cal(L)(f(x; theta), t(x))]$