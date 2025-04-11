= Probabilistic Learning

\ Bayes Rule: $P(m | E) = (P(E | m) times P(m))/P(E)$

\ Prior Probability: Agent's beliefs before any observations. $P(h)$
\ Posterior Probability: Updated beliefs after observing. $P(h | e)$

\ Bayesian Probability: View of probability as measure of belief (Epistimological-Pertain to knowledge)
\ Frequentist Probability: Probability is dependent on observations (Ontological - How world is)

\ Joint Probability: P(X, Y) is probability X and Y are both true

\ Proposition: Assignment of value to a variable

Axioms of Probability:
- $P(x) > 0$
- $sum P(x) = 1$
- $P(A or B) = 1$ if $P(A)$ and $P(B)$ are impossible at same time.

*Note*: 1 is simply convention—could be anything else.

$P(h | e) = P(h | e = "True") = P(h and e)/P(e)$

\ Chain Rule: $P(a_1 and a_2 and dots and a_n) = P(a_n | a_(n-1) and dots and a_1) times dots times P(a_2 | a_1) times P(a_1)$

\ Marginal Distribution: Given Joint distribution, marginalize out some of the variables to isolate for a subset. 

$P(Y=y) = sum_x P(X = x, Y = y)$

\ Independence: $P(X, Y) = P(X)P(Y), P(X) = P(X|Y)$
\ Conditional Independence: $P(X, Y | Z) = P(X|Z)P(Y|Z), P(X|Z) = P(X|Y, Z)$

\ Expected Value: $EE(X) = sum_(v in "domain"(X)) V(X) P(X)$
\ Bayesian Decision Making: $max_"decision" EE(V("decision")) = max_"decision" sum_"outcome" P("outcome" | "decision") V("decision")$

Complete independence means we can represent a probability distribution by the distributions over each individual variable instead of joint connections, reducing space and calculation complexity from $O(2^n)$ to $O(n)$

== Belief Networks
Directed acyclic graph with dependencies for each event.
_Bayesian networks don't imply causality, just correlation. Having causality makes reasoning with network easier_

We can say $A$ is independent of $B$ given $C$ if learning $C$ makes $B$ irrelevant information. However, without $C$, it's possible learning $B$ is valuable.

\ Conditional Probability Table: Stores probability distribution on $X$ given parents. $P(X_i | "parents"(X_i))$ for each $X_i$

#image("../assets/conditional_probability_table.png")

== Updating Beliefs
Given prior belief $P(h)$, and evidence $e$ with likelihood given hypothesis $P(e | h)$, posterior belief after observing evidence is $P(h | e)$. You can calculate this posterior with Bayes' Rule. 

$
  P(h | e) = (P(e | h)P(h))/P(e) = (P(e | h)P(h))/(sum)
$