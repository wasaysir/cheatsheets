= Reasoning Under Uncertainty

== Probability

\ Prior Probability: Belief of agent before it observes anything
\ Posterior Probability: Updated belief (after discovering information - observation)

\ Bayesian Probability: Probability as a measure of belief (Different agents can have different information, so different beliefs)

\ Epistemology: A value based on one's belief
\ Ontology: A veritable fact of the world

The belief in a proposition $alpha$ is measured in between $0$ and $1$, where $0$ means it's *believed* to be definitely false (no evidence will shift that) and $1$ means it's believed to be definitely true. Note the bounds are arbitrary. A value in between $0$ and $1$ doesn't reflect the variability of the truth, but rather strength of agent's belief.

*Worlds*: Semantics are defined in terms of "possible worlds", each of which is one way the world could be. There is only one true world, but real agents aren't omniscient, and can't tell.

\ Random Variable: Function on worlds—given world, it returns a value. Set of values it returns is the domain of the variable.

\ Primitive Proposition: Assignment of a value to a variable, or inequality between variable and value, or between variables.

\ Proposition: A connection between primitive propositions using logical connectives, that is either true or false in a world.

\ Probability Measure: Function $mu$ from sets of world, into nonnegative real numbers that satisfies two constraints: If $Omega_1$ and $Omega_2$ are disjoint sets of worlds, then $mu(Omega_1 union Omega_2) = mu(Omega_1) + mu(Omega_2)$ and $mu(Omega) = 1$ where $Omega$ is the set of all possible worlds.

*Probability of Proposition*: Probability of proposition $alpha$, written $P(alpha)$ is measure of set of possible worlds where $alpha$ is true, so $P(alpha) = mu({omega: alpha "is true in " omega})$

\ Probability Distribution: If $X$ is random variable, $P(X)$ is function from domain of $X$ onto real numbers such that given $x in "domain"(X)$, $P(X)$ is probability of proposition $X = x$

\ Joint Probability Distribution: If $X_1, dots, X_n$ are all of the random variables, then $P(X_1, dots, X_n)$ is the distribution over all worlds, and an assignment to the random variables corresponds to a world.

=== Infinite Worlds
There can be infinitely many worlds if domain of variable is infinite, infinitely many variables (ex. variable for location of robot for every second from now into the future)

The probability of $X = v$ can be zero for a variable with continuous domain, but between a range of values, $v_0 < X < v_i$ it can have real-values (think of probability function), therefore a *probability density function* is used: $P(a lt.eq X lt.eq) = integral_a^b p(X) d X$

\ Parametric Distribution: Density function is defined by formula with free parameters. 

\ Nonparametric Distribution: Probability function where number of parameters is not fixed, such as in decision tree.

\ Discretization: Convert continuous variables into discrete values (like heights that are converted into separate regions and then capped)

== Conditional probability

\ Evidence: Proposition $e$ representing conjunction of all of agent's observations

\ Posterior Probability: $P(h | e)$, given evidence $e$, belief of $h$
\ Prior Probability: $P(h)$, without any evidence, what is initial assumption of $h$

*Formal Definition of prior probability*:
$mu_e(S) = cases(
  c times mu(S) "if e is true in " omega "for all " omega in S,
  0  "if e is false in " omega "for all " omega in S,
)$

Then, for $mu_e$ to be probability distribution: 
$
  1 &= mu_e(Omega) \
  &= mu_e({w: e "true in " w}) + mu_e({w: e "false in " w}) \
  &= c times mu({w : e "true in" w}) + 0 \
  &= c times P(e)
$

So $c = 1 / P(e)$

*Formal definition of posterior probability*:
$
  P(h | e) &= mu_e({omega: h "true in " omega}) \
  &= mu_e ({omega: h and e "true in" omega}) + mu_e({omega: h and not e "true in" omega}) \
  &= 1/(P(e)) mu({omega: h and e "true in " omega}) + 0 \
  &= (P(h and e))/(P(e))
$

*Chain Rule*:
$
  P(a_1 and dots and a_n) &= P(a_n | a_1 and dots and a_(n-1)) times P(a_1 and dots and a_(n-1)) \
   &= P(a_n | a_1 and dots and a_(n-1)) times dots times P(a_2 | a_1) times P(a_1) \
   &= product^n_(i=1) P(a_i | a_(i-1) and dots and a_1)
$

== Bayes Rule
Given current belief in proposition $h$ based on evidence $k$, given new evidence $e$ we update the belief as follows:

$P(h | e and k) = (P(e | h and k)) times P(h | k))/P(e | k)$ $("assuming" P(e | k)) eq.not 0$

Simplifying by keeping $k$ implicit, we get:

$P(h | e) = (P(e | h) times P(h))/(P(e))$

\ Expected Value ($xi_P(X) = sum_(v in "domain"(X)) v times P(X = v)$) if finite/countable, integral if continuous.

== Independence

\ Conditional independence: If $P(X | Y, Z) = P(X | Z)$, then $X$ is conditionally independent of $Y$

\ Unconditional Independence: If $P(X, Y) = P(X)P(Y)$, so they are conditionally independent given no observations. Note this doesn't imply they are conditionally independent.

\ Context-specific independence: Variables $X$ and $Y$ are independent with respect to context $Z = v$ if $P(X | Y, Z = v) = P(X | Z = z)$ that is it is conditionally independent for one specific value of $Z$

== Belief Networks
\ Markov Blanket: Set of locally affecting variables that directly affect $X$'s value. 

\ Belief Network: Directed Acyclic Graph representing conditional dependence among a set of random variables. Nodes are random variables. Edges are direct dependence. Conditional independence is determined by an ordering of the variables; each variable is independent of its predecessors in total ordering given a subset of the predecessors called the parents. Independence is indicated by missing edges.

