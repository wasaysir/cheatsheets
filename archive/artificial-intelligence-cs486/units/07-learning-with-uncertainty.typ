= Probabilistic Learning

/ Bayes Rule: $P(m | E) = (P(E | m) times P(m))/P(E)$

/ Prior Probability: Agent's beliefs before any observations. $P(h)$
/ Posterior Probability: Updated beliefs after observing. $P(h | e)$

/ Bayesian Probability: View of probability as measure of belief (Epistimological-Pertain to knowledge)
/ Frequentist Probability: Probability is dependent on observations (Ontological - How world is)

/ Joint Probability: P(X, Y) is probability X and Y are both true

/ Proposition: Assignment of value to a variable

Axioms of Probability:
- $P(x) > 0$
- $sum P(x) = 1$
- $P(A or B) = 1$ if $P(A)$ and $P(B)$ are impossible at same time.

*Note*: 1 is simply convention—could be anything else.

$P(h | e) = P(h | e = "True") = P(h and e)/P(e)$

/ Chain Rule: $P(a_1 and a_2 and dots and a_n) = P(a_n | a_(n-1) and dots and a_1) times dots times P(a_2 | a_1) times P(a_1)$

/ Marginal Distribution: Given Joint distribution, marginalize out some of the variables to isolate for a subset. 

$P(Y=y) = sum_x P(X = x, Y = y)$

/ Independence: $P(X, Y) = P(X)P(Y), P(X) = P(X|Y)$
/ Conditional Independence: $P(X, Y | Z) = P(X|Z)P(Y|Z), P(X|Z) = P(X|Y, Z)$

/ Expected Value: $EE(X) = sum_(v in "domain"(X)) V(X) P(X)$
/ Bayesian Decision Making: $max_"decision" EE(V("decision")) = max_"decision" sum_"outcome" P("outcome" | "decision") V("decision")$

Complete independence means we can represent a probability distribution by the distributions over each individual variable instead of joint connections, reducing space and calculation complexity from $O(2^n)$ to $O(n)$

== Belief Networks
Directed acyclic graph with dependencies for each event.
_Bayesian networks don't imply causality, just correlation. Having causality makes reasoning with network easier_

We can say $A$ is independent of $B$ given $C$ if learning $C$ makes $B$ irrelevant information. However, without $C$, it's possible learning $B$ is valuable.

/ Conditional Probability Table: Stores probability distribution on $X$ given parents. $P(X_i | "parents"(X_i))$ for each $X_i$

#image("../assets/conditional_probability_table.png")

== Updating Beliefs
Given prior belief $P(h)$, and evidence $e$ with likelihood given hypothesis $P(e | h)$, posterior belief after observing evidence is $P(h | e)$. You can calculate this posterior with Bayes' Rule. 

$
  P(h | e) = (P(e | h)P(h))/P(e) = (P(e | h)P(h))/(sum_h P(e|h) P(h))
$

Bayes' Theorem allows you to determine evidential reasoning from causal knowledge.

Forward Inference Rules:

/ Marginalization: $P(B) = sum_(m, c) P(M = m, C = c, B)$
/ Chain Rule: $P(B) = sum_(m, c) P(B | M, c) P(m | c) P(c)$
/ Independence: $P(B) = sum_(m, c) P(B | m, c) P(m) P(c)$
/ Distribution of product over sum: $P(B) = sum_m P(m) sum_c P(c) P(B | m, c)$ 

Backward Inference Rules:
When evidence is downstream of query, we reason "backwards", using Bayes' rule.

== Variable Elimination

Generalization that applies sum-out rule repeatedly to determine conditional probabilities.

=== Factors
/ Factor: Representation of a function from tuple of random variables into a number. 
/ Restricting a factor: Assigning some or all of the variables of a factor.

/ Product of Factor: $f_1(X, Y)$ and $f_2(X, Y)$ where $Y$ are the common variables is factor $(f_1 times f_2)(X, Y, Z) = f_1(X, Y)f_2(Y, Z)$

/ Sum out: $X_1$ with domain ${v_1, dots, v_k}$ from factor $f(X_1, dots, X_j)$ resulting in factor on $X_2, dots, X_j$ as $sum_(X_1)f (X_2, dots, x_j) = f(X_1 = v_1, dots, X_j) + dots + f(X_1=v_k, dots, X_j)$

=== Evidence
To find posterior probability of $Z$ given evidence $Y_1 = v_1 and dots and Y_j = v_j$
$P(Z|Y_1 = v_1, dots Y_j = v_j) = (P(Z, Y_1 = v_1, dots, Y_j = v_j))/(P(Y_1=v_1, dots, Y_j=v_j)) = (P(Z, Y_1 = v_1, dots, Y_j=v_j))/(sum_Z P(Z, Y_1 = v_1, dots, Y_j = v_j))$

Thus the posterior is the joint probability of query and evidence, normalized at the end. 

=== Conjunction Probability
Suppose query $Z$ and evidence $Y$, then we can achieve remaining variables $M_1, dots, M_k = {X_1, dots, X_n} - {Z} - {Y_1, dots, Y_j}$ and sort into elimination ordering. Then $P(Z, Y=v_1, dots, Y_j =v_j) = sum_Z_k dots sum_Z_1 P(X_1, dots, X_n)_(Y_1=v_1, dots, Y_j=v_j) = sum_Z_k dots sum_Z_1 product^n_(i=1) P(X_i | "parents"(X_i))_(Y_1=v_1, dots, Y_j=v_j)$

=== Variable Elimination Algorithm

+ Construct factor for each conditional probability
+ Restrict observed vars to observed vals
+ Sum out non-relevant variables in some elimination ordering: For each $Z_i$ starting from $i=1$
    + Collect factors containing $Z_i$
    + Multiply together and sum out $Z_i$
    + Add resulting new factor back to pool
+ Multiply remaining factors
+ Normalize by dividing resulting factor $f(Z)$ by $sum_Z f(Z)$

==== Summing out Variable
To sum out variable $Z_j$ from product $f_1, dots, f_k$ of factors, partition factors into those containing $Z_j$ and those that don't, resulting in:
$sum_Z_j f_1 times dots f_k = f_1 times dots f_i times (sum_Z_j f_(i+1) times dots times f_k)$

Then create an explicit representation of rightmost factor $sum_Z_j f_(i+1) times dots times f_k$ and replace factors $f_(i+1), dots, f_k$ by new factor.

=== Variable Elimination Considerations
- Complexity is linear in number of variables, and exponential in size of largest factor.
- When creating new factors, sometimes this blows up, depending on elimination ordering
- For polytrees: work outside in, for general Bayesian Networks, this can be hard.
- Finding optimal elimination ordering is NP-hard for general BNs
- Inference in general is NP-hard
- Better to eliminate singly-connected nodes because no factor is ever larger than original CPT
- Some variables have no impact on certain other variables, so need to sum.
- To remove irrelevant variables, ensure query $Q$ is relevant; if any node is relevant, its parents are relevant. If $E in "Evidence"$, is descendent of relevant variable, then $E$ is relevant. 

== Probability and Time
- Node can repeat over time, into discrete explicit encodings of time. 
- Either event-driven time or clock-driven time
- Represented by Markov Chain
- Chain length represents amount of time you want to model

/ Markov Assumption: $P(S_(t+1)|S_1, dots, S_t) = P(S_(t+1)|S_t)$

=== Hidden Markov Models

Given observations $O_1, dots, O_t$ we can estimate $P(S_t | O_1, dots, O_t)$, or $P(S_k | O_1, dots, O_t), k < t$

#image("../assets/hidden_markov_models.png")

=== Dynamic Bayesian Networks

Any Bayesian network can repeat over time as a Dynamic Bayesian Network.

Through sensor fusion, Bayesian probabilities ensures that evidence is integrated proportionally to its precision, with precision weight sensors.

=== Stochastic Simulation

/ Monte Carlo Simulation: Stochastic sampling from distribution to estimate probabilities.

To generate samples from a distribution, totally order values of domain of $X$, generate PCF, select value in range $[0, 1]$, select $x$ such that $f(x) = y$

Forward Sampling in Belief Network:
+ Sample Variables one at a time
+ Sample parents of $X$ before sampling $X$
+ Given values for parents of $X$, sample from probability of $X$ given parents
+ For samples $s_i, 1 dots N$: $P(X=x_i) prop sum_s_i delta(x_i) = N_(X=x_i)$

$P(H = h_i | E=e_i) = (P(H=h_i) and E=e_i)/(P(E=e_i)) = (N(h_i, e_i))/(N(e_i))$