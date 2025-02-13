#import "@preview/lovelace:0.3.0": *

= Learning
*Learning*: Ability to improve behaviour based on experience. Either improve range (more abilities), accuracy, or speed.

*Components of learning problem*:
- Task: Behaviour to improve (Ex: Classification)
- Data: Experiences used to improve performance
- Improvement metric

*Common Learning Tasks*:
- Supervised classification: Given pre-classified training examples, classify new instance
- Unsupervised learning: Find natural classes for examples
- Reinforcement learning: Determine what to do based on rewards and punishments
- Transfer Learning: Learn from expert
- Active Learning: Learner actively seeks to learn
- Inductive logic programming: Build richer models in terms of logic programs

*Learning by feedback*:
- Supervised learning: What to be learned is specified for each example
- Unsupervised learning: No classifications given, learner has to discover categories from data
- Reinforcement learning: Feedback occurs after a sequence of actions

*Metrics*:
Measure success by how well agent performs for new examples, not training.
*P agent*: Consider this agent that claims negative training data are the only negative instances, and gives positive otherwise (100% training data, bad test)
*N agent*: Same as N agent, but considers only positive training data.
They both have 100% on training data, but disagree on everything else.

*Bias*:
Tendency to prefer one hypothesis over another. Necessary to make predictions on unseen data. You can't evaluate hypotheses by the training data, it depends on what works best in practice (unseen data).

*Learning as search*: Given representation and bias, learning is basically a search through all possible representations looking for representation that best fits the data, given the bias. However, systematic search is infeasible, so we typically use a *search space*, *evaluation function*, and a, *search method*

== Supervised Learning
Given input features, target features, training examples and test examples we want to predict the values for the target features for the test examples. 
*Classification*: When target features are discerete.
*Regression*: When target features are continuous.

*Noise*: Sometimes features are assigned wrong value, or inadequate for predicting classification, or missing features. 
*Overfitting*: Distinction appears in data that doesn't exist in unseen examples (through random correlations)

== Evaluating Predictions
$Y(e)$ is value of feature $Y$ for example $e$
$accent(Y, hat)(e)$ is predicted value of feature $Y$ for example $e$ from the agent.
*Error* is prediction of how close $accent(Y, hat)(e)$ is to $Y(e)$

=== Measures of Error
- Absolute error: $sum_(e in E) sum_(Y in T) abs(Y(e) - accent(Y, hat)(e))$
- Sum of squares: $sum_(e in E) sum_(Y in T) (Y(e) - accent(Y, hat)(e))^2$
- Worst-case: $max_(e in E) max_(Y in T) abs(Y(e) - accent(Y, hat)(e))$
- Cost-based error takes into account costs of various errors, so some are more costly than others.

=== Precision and Recall
*Recall*: Percentage of positive statements that are accurately predicted
*Specificity*: Percentage of negative statements that are accurately predicted
*Precision*: Percentage of predicted truths that are correct.

*Receiver Operating Curve*: A graph between True positives and False Positives

#figure(
    image("../assets/receiverOperatingCurve.png")
)

*Basic Models*: Decision Trees, Linear classifiers (Generalize to Neural Networks), Bayesian Classifiers

= Decision Trees
*Representation* is a decision tree
*Bias* is towards a simple decision tree
*Nodes*: Input attributes/features
*Branches*: Labeled with input feature values (can have multiple feature values)
*Leaves*: Predictions for target features (point estimates)
Search through the space of decision trees from simple to complex decision trees

*Learning*:
- Incrementally split training data
- Recursively solve sub-problems
- Try to get small decision tree with good classification (low training error) and generalization (low test error)

*Learn Pseudocode*:
#pseudocode-list[
  + X is input features, Y output features, E is training examples
  + Output is decision tree (Either Point estimate of Y or form $angle.l X_i, T_1, dots, T_N angle.r$ where $X_i$ is input feature and $T_1, dots, T_N$ are decision trees.
  + procedure DecisionTreeLearner(X, Y, E):
    + if stopping criteria is met then
        + return pointEstimate(Y, E)
    + select feature $X_i in X$
        + for each value $x_i in X_i$ do
            + $E_i = $ all examples in E where $X_i = x_i$
            + $T_i = $ DecisionTreeLearner($X \ {X_i}, Y, E_i$)
        + return $angle.l X_i, T_1, dots, T_N angle.r$
]

*Classify Pseudocode*:
#pseudocode-list[
    + X: input features, Y: output features, e: test example, DT: Decision Tree
    + procedure ClassifyExample(e, X, Y, DT)
        + S $arrow.l$ DT
        + while S is internal node of form $angle.l X_i, T_1, dots, T_N angle.r$
            + $j arrow.l X_i(e)$
            + $S arrow.l T_j$
        + return S
]

*Stopping Criteria*:
- Stopping criteria is related to final return value
- Depends on what we will need to do
- Possible: Stop when no more features, or when performance is good enough

*Feature Selection*:
We want to choose sequence of features resulting in smallest tree. Actually we should myopically split, as if only allowed one split, which feature would give best performance.

*Heuristics*:
- Most even split
- Maximum information gain
- GINI index

== Information Theory
Bit is binary digit, $n$ bits classify $2^n$ items, straight up. But if we use probabilities we can make the average bit usage lower.
Eg: P(a) = 0.5, P(b) = 0.25, P(c) = P(d) = 0.125
If we encode a:00, b: 01, c: 10, d: 11, it uses on average 2 bits.
If we encode a:0, b: 10, c: 110, d: 111, it uses on average 1.75 bits.

In general we need $- log_2 P(x)$ bits to encode $x$, each symbol needs on average $-P(x) log_2 P(x)$ bits and to transmit an entire sequence distributes according to $P(x)$ we need on average $sum_x -P(x) log_2 P(x)$ bits (entropy/information content)

== Information Gain
Given a set $E$ of $N$ training examples, if number of examples with output feature $Y=y_i$ is $N_i$ then $P(Y=y_i) = P(y_i) = N_i/N$ (Point estimate)

Total information content for set $E$ is $I(E) = -sum_(y_i in Y) P(y_i) log_2 P(y_i)$

So after splitting $E$ into $E_1$ and $E_2$ with size $N_1, N_2$ based on input attribute $X_i$, the information content is $I(E_"split") = N_1/N I(E_1) + N_2/N I(E_2)$ and we want the $X_i$ that maximizes information gain $I(E) - I(E_"split")$

Note:
$
  N_1/N I(E_1) + N_2/N I(E_2) &= -N_1/N (sum_(y in Y)P(y | x = 1)log P(y | x = 1)) - N_2/N (sum_(y in Y)P(y | x = 2)log P(y | x = 2)) \
  &= -sum_(y in Y)P(x=1) P(y | x = 1)log P(y | x = 1) - sum_(y in Y)P(x=2)P(y | x = 2)log P(y | x = 2) \
  &= -sum_(x in X, y in Y)P(x=x) P(y | x = x)log P(y | x = x) \
  &= -sum_(x in X, y in Y)P(x, y)log P(x, y)/P(x) &"By definition of P(y | x)"\
$

*Final Return Value*:
*Point estimate* of $Y$ (output features) over all examples. This is just a prediction of target features. (Eg: Mean, Median, most likely classification, $P(Y = y_i) = N_i/N$)

== Priority Queue
Basic version grows all branches for a node in decision tree, but it's more efficient to sort leaves via priority queue ranked by how much information can be gained with best feature at that leaf and always expand leaf at top of queue.

*Overfitting*: When decision tree is too good at classifying training it doesn't generalize well, occurs with insufficient data.
Methods to fix:
- Regularization: Prefer small decision trees over big ones (complexity penalty)
- Pseudocounts: Add some data based on prior knowledge
- Cross validation: Partition into training and validation set. Use validation set as test set and optimize decision maker to perform well on validation set, not training set. 
- Errors can be caused by: 
    - Bias:
        - Represntation bias: Model is too simple
        - Search bias: Not enough search
    - Variance: Error due to lack of data
    - Noise: Error from data depending on features not modeled, or because process generating data is stochastic.
    - Bias-variance trade-off:
        - Complicated model, not enough data (low bias, high variance)
        - Simple model, lots of data (high bias, low variance)
    - Capacity: Ability to fit wide variety of functions (inverse of bias)