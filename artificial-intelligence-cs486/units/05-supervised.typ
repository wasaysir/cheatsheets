#import "@preview/lovelace:0.3.0": *

= Supervised Learning
/ Learning: Ability to improve behaviour based on experience. Either improve range (more abilities), accuracy, or speed.

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

/ Metrics:
Measure success by how well agent performs for new examples, not training.
/ P agent: Consider this agent that claims negative training data are the only negative instances, and gives positive otherwise (100% training data, bad test)
/ N agent: Same as N agent, but considers only positive training data.
They both have 100% on training data, but disagree on everything else.

/ Bias:
Tendency to prefer one hypothesis over another. Necessary to make predictions on unseen data. You can't evaluate hypotheses by the training data, it depends on what works best in practice (unseen data).

/ Learning as search: Given representation and bias, learning is basically a search through all possible representations looking for representation that best fits the data, given the bias. However, systematic search is infeasible, so we typically use a *search space*, *evaluation function*, and a, *search method*

/ Interpolation: Inferring results in between training examples (Ex: Train on 1,2,4,5. Test on 3)
/ Extrapolation: Inferring results beyond training examples (Ex: Train on 1, 2, 4, 5. Test on 1000)

== Supervised Learning
Given input features, target features, training examples and test examples we want to predict the values for the target features for the test examples. 
/ Classification: When target features are discerete.
/ Regression: When target features are continuous.

/ Noise: Sometimes features are assigned wrong value, or inadequate for predicting classification, or missing features. 
/ Overfitting: Distinction appears in data that doesn't exist in unseen examples (through random correlations)

== Evaluating Predictions
$Y(e)$ is value of feature $Y$ for example $e$
$accent(Y, hat)(e)$ is predicted value of feature $Y$ for example $e$ from the agent.
/ Error: Prediction of how close $accent(Y, hat)(e)$ is to $Y(e)$

=== Types of Features
/ Real-Valued Features: Values are totally-ordered. Ex: Height, Grades, Shirt-size. (The finitenss of the domain of values is irrelevant)

/ Categorical Features: Domain is fixed finite set. (Total-ordering is irrelevant). Point estimates are either definitive predictions or probabilistic predictions for each category.

=== Measures of Error
/ Absolute error: $sum_(e in E) sum_(Y in T) abs(Y(e) - accent(Y, hat)(e))$
/ Sum of squares: $sum_(e in E) sum_(Y in T) (Y(e) - accent(Y, hat)(e))^2$
/ Worst-case: $max_(e in E) max_(Y in T) abs(Y(e) - accent(Y, hat)(e))$
- Cost-based error takes into account costs of various errors, so some are more costly than others.
/ Mean Log Loss: For probabilistic predictions, calculate the mean log loss ($"logloss"(p, a) = - log(p[a])$) for all predictions (p = pred, a = acc). Mean log loss is a transformation of log-likelihood, so minimizing mean log loss finds highest likelihood.
/ Binary Log Loss: $"logloss"(p, a) = -a log p - (1-a) log(1-p)$ is a variant for boolean features.

=== Precision and Recall
/ Recall: Percentage of positive statements that are accurately predicted
/ Specificity: Percentage of negative statements that are accurately predicted
/ Precision: Percentage of predicted truths that are correct.

/ Receiver Operating Curve: A graph between True positives and False Positives

#figure(
    image("../assets/receiverOperatingCurve.png")
)

/ Basic Models: Decision Trees, Linear classifiers (Generalize to Neural Networks), Bayesian Classifiers

== Decision Trees
- Representation: Decision tree
- Bias: Tendency towards a simple decision tree
/ Nodes: Input attributes/features
/ Branches: Labeled with input feature values (can have multiple feature values)
/ Leaves: Predictions for target features (point estimates)
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
  &N_1/N I(E_1) + N_2/N I(E_2) \
  &= -N_1/N (sum_(y in Y)P(y | x = 1)log P(y | x = 1)) \
  &- N_2/N (sum_(y in Y)P(y | x = 2)log P(y | x = 2)) \
  &= -sum_(y in Y)P(x=1) P(y | x = 1)log P(y | x = 1) \
  &- sum_(y in Y)P(x=2)P(y | x = 2)log P(y | x = 2) \
  &= -sum_(x in X, y in Y)P(x=x) P(y | x = x)log P(y | x = x) \
  &= -sum_(x in X, y in Y)P(x, y)log P(x, y)/P(x) \
  &"By definition of P(y | x)"\
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

== Linear Regression
The goal is to fit a linear function a set of real-valued training data. 
The linear function would be a combination of weights, which we can optimize over by taking the partial derivative of the loss for each weight, setting to 0, and solving the linear system (ex. a la RANSAC)

=== Squashed Linear Functions
Linear functions don't make sense for *binary classification* because we shouldn't extrapolate beyond the domain $[0, 1]$ which linear functions allow us to do. The solution is to use a function with domain $[-infinity, infinity]$ and range $[0, 1]$ to transform a linear function onto sensical binary domain.

/ Activation Function: Funciotn that transforms from real $(- infinity, infinity)$ to subset $[0, 1]$

To determine weights for a squashed linear function, you need to minimize the *log loss*. 

/ Log Loss: $"LL"(E, w) = -1/abs(E) times sigma_(e in E) (Y(e) times log accent(Y, hat)(e) + (1 - Y(e)) times log(1 - accent(Y, hat)(e)))$ ($accent(Y, hat)(e)$) is the predicted value after transformation. To optimize for this function, take partial derivatives for each weight and find their minimal.

=== Stochastic Gradient Descent
The goal is to find a local minimum of weights according to some error function, based on some initial value, learning rate, and partial derivative of weights to error.

The definition of gradient descent requires all training data to be interetpreted. Stochastic gradient descent uses a random sample (batch) before updating its weights.

/ Batch: Set of $b$ examples used in each update
/ Epoch: $ceil(abs(E s)/b)$ batches, which is one pass through all data (on average)

*Linear Learner*:
#pseudocode-list[
    + *Inputs*: 
        + _Xs_: set of input features
        + _Y_: Target Feature
        + _Es_: Set of training examples
        + $eta$: learning rate
        + $b$: batch size
    + *Output*: Funciton to make prediction on examples
    + *Algorithm*:
        + Initialize weights randomly
        + Define squashed linear regression prediction function
        + initialize derivative values to 0
        + Select batch _B_ of size $b$ from _Es_
        + *for each* example _e_ in _B_
            + Predict target and find error
            + for each weight, add the partial derivative of error to derivative values
        + *for each* weight take gradient descent step
    + *Return*: Prediction algorithm based on weights
]

Smaller batch sizes learn faster, but may not converge to local optimum, because you're more influenced by the randomness of your selection process. 

/ Incremental Gradient Descent: Select batches of size 1 to update. Used for streaming data where each example is used once and then discarded. 
/ Catastrophic forgetting: Discarding older data (and not using it again) means you fit later data better but forget earlier examples.

=== Linear Separability
Each input feature can be viewed as a dimension, and a hyperplane can separate an $m$-dimensional space into two spaces.
/ Linearly separable: A dataset is linearly separable if there exists a hyperplane where the classification is true on one side and false on other side.

=== Categorical Target Features
/ Indicator Variables: Technique to transform a categorical feature into a set of binary variables (If you have a categorical feature or not)

One issue with indicator variables is that, if we can only use one value, then the predicted probabilities should add to 1. One way to ensure this is to only learn for all but one variables and make the remaining variable's value the difference to 1, but this doesn't work because errors for other values accumulate but the non-trained value's errors don't. 

One solution is to find a linear function for each value, exponentiate, and normalize. For instance, take the softmax function:

$"softmax"((alpha_1, dots, alpha_k))_i = (exp(alpha_i)/(sum^k_(j=1) exp(alpha_j)))$

This guarantees all values are positive and sum to 1, so are proper analogs for probability distribution.

/ Multinomial Logistic Regression: Given the categorical functions with $k$ values, we can generalize our linear function into $u_j(e) = w_(0, j) + X_1(e) times w_(1, j) + dots + X_m(e) times w_(m, j)$ Note we have one linear function for each output value, so our weights are $w_(i j)$ for input i, output j.

/ Categorical Log Loss: Take the log loss of the softmax function.

#image("../assets/categoricalLogLoss.png")
Here we only compare the predicted target value against the test target feature.

/ One-hot encoding: Given complete set of values where only one value is $1$ and rest are $0$

== Overfitting
A complex model (with many degrees of freedom) has a better chance of fitting to the training data. 

/ Bias: The error due to the algorithm finding an imperfect model. This is the deviation between the model found and the ground truth model.

/ Representation Bias: Representation does not contain a model close to the ground truth
/ Search Bias: Algorithm hasn't searched enough of the search space to find a better model. 

/ Variance: Error from lack of data. 

/ Bias-Variance Trade-Off: Complicated models can be accurate, but without sufficient data it can't estimate it properly (low bias, high variance). Simple models cannot be accurate, but can estimate model well given data (high bias, low variance)

/ Noise: Inherent error due to data depending on features not modeled or because data collection is inherently stochastic.

/ Overconfidence: Learner is more confident in prediction than data warrants. 

=== Pseudocounts
Optimal prediction is usually the mean, however, this is not a good estimate for new cases, so we minimize the weight of the mean through pseudo-examples:

$accent(v, hat) = (c times a_0 + sum_i v_i)/(c + n)$, this value is a "weighted" mean, which minimizes the relative influence of the actual mean. $a_0$ is some defined set value. 

=== Regularization

In addition to trying to fit a model to data, also include a term that rewards simplicity and penalizes complexity. 

/ Ridge Regression: A linear regression function with an L2 regularizer
/ Lasso (Least Absolute Shrinkage and Selection Operator): Loss function + L1 regularizer

/ Feature Selection: The use of specific features for calculation. L1 regularization does this by making many weights zero.

=== Cross Validation
Instead of separate training and test sets, we go one step further. We have one training set, one validation set, and one test set (each completely separate).

/ Validation Set: This is an emulation of the test set, used to optimize the hyperparameters of the model. 

Note, we want to train on as many examples as possible to get better models, so partitioning our data into three is not ideal. We use *k-fold cross validation*.

*k-fold cross validation*:
- Partition non-test examples randomly into $k$ sets of approximately equal size, called folds. 
- For each parameter, train $k$ times for that parameter setting, using one of the folds as the validation set and remaining folds for training. 
- Optimize parameter settings based on validation errors
- Return model with selected parameters trained on all data.

== Composite Models
Although linear functions and decision trees can't be used to represent many functions, combining linear functions with non-linear inputs is a way to use simple linear models but make them more accurate.

/ Kernel Function: Function applied to input features to create new features. (Ex. $x^2, x^3, x y$)

/ Regression Tree: Decision Tree with constant function at each leaf (piecewise constant function)

/ Piecewise Linear Function: Decision Tree with linear function at leaves.

/ Ensemble Training: Using multiple learners, combine outputs via some function to create an ensemble prediction. 

/ Base-level algorithms: Algorithms used as inputs for ensemble learners.

/ Random Forest: Using multiple decision trees make predictions through each tree and combine outputs. This works best if trees make diverse predictions: Each tree uses different subset of examples to train on (bagging) or subset of conditions for splitting are used. 

=== Boosting
/ Boosting: Sequence of learners where each learns from errors of previous ones.

*Boosting Algorithm*:
- Base learners exist in sequence.
- Each learner is trained to fit examples previous learners didn't fit well.
- Final prediction uses a composite of predictions of each learner.
- Base learners don't have to be good, but have to be better than random.

/ Functional Gradient Boosting: 
Given hyperparameter $K$ with $K$ base learners, final prediction as function of inputs is $p_0 + d_1(X) + dots + d_k(X)$ where $p_0$ is initial prediction and $d_i$ is difference from previous prediction (i.e. $p_i(X) = p_(i-1)(X) + d_i(X)$) 
Given $p_(i-1)$ is fixed, the learners meant to optimize for $accent(d_i, hat)$ optimize for: $sum_e "loss"(p_(i-1)(e) + accent(d_i, hat)(e), Y(e)) = sum_e "loss"(accent(d_i, hat)(e), Y(e) - p_(i-1)(e))$

=== Gradient-Boosted Trees
/ Gradient-Boosted Trees: Linear models where features are decision trees with binary splits, learned using boosting.

The prediction for example $(x_e, y_e)$ is $accent(y_e, hat) = sum^K_(k=1) f_k(x_e)$

Each $f_k$ is a decision tree, each leaf has a corresponding output $w_j$ (we call this the weight because of how it weighs to the larger sum). We also have a function $q$ which corresponds to the if-then-else structure of the tree. For simplicity, we represent $w$ as a single vector of weights, so instead of the tree hierarchy, we use a vector to store all the weights for quick compute, and $q$ maps onto this vector (just so simplify tree traversal).

The loss function is: $cal(L) = (sum_e (accent(y_e, hat) - y_e)^2) + sum_(k=1)^K Omega(f_k)$

$Omega(f) = gamma dot abs(W) + 1/2 lambda dot sum_j w_j^2$, this is the regularization term to minimize the weights. $abs(W)$ minimizes the number of leaves. The lambda product minimizes the values of the parameters. $gamma$ and $lambda$ are non-negative learnable parameters.

==== Choosing Leaf Values
The model is learnt using boosting, so each tree is learned sequentially. Consider building the $t$th tree, where previous are fixed. Assume (for simplicity) that the tree structure (q) is fixed. Lets optimize for the weight of a single leaf $w_j$. Let $I_j = {e | q(x_e) = j}$ be the set of training examples that map to the $j$th leaf. 

Since the $t$th tree is learnt, for regression, the loss for the $t$th tree is:
$cal(L)^((t)) = 1/2 lambda * sum_j w_j^2 + sum_e (y_e - sum^t_(k=1) f_k(x_e))^2 + "constant" = 1/2 lambda * sum_j w_j^2 + sum_e (y_e - sum^(t-1)_(k=1) f_k(x_e) - w_j)^2 + "constant" $ where constant is regularization values for previous trees and size of tree.

Therefore, the minimum value for $w_j$ is $w_j = (sum_(e in I_j)(y_e - accent(y_e, hat)^((t-1))))/(abs(I_j) + lambda)$

For classification, when you take the derivative, it's difficult to solve analytically, so instead an approximation is used in the opposite step of the gradient. 

==== Choosing Splits
Proceed greedily. Start with single leaf, find best leaf to expand to minimize loss. For small datasets look through every split, for larger splits, take subsamples or pre-computed percentiles. 

=== No-Free-Lunch Theorem
No matter the training set, for any two definitive predictors A and B, there are as many functions from the input feature sto target features consistent with evidence that A is better than B on off-training set (examples not in training) as when B is better than A on off-training set.

Consider m-Boolean input features, then there are $2^m$ assignments of input features, and $2^(2^m)$ functions from assignments onto {0, 1}. If we assume uniform distribution over functions, we can use $2^m$ bits to represent a function (one bit for each assignment, basically a lookup), and memorize the training data. Then for a training set of size $n$, we'll set $n$ of these bits, but the remaining bits are free to be assigned in any way, as in there is a wide class of functions that it could be.