= Inference and planning
== Problem Solving
\ Procedural solving: Devise algorithm, program, execute
\ Declarative solving: Identify required knowledge, encode knowledge in representation, use logical consequences to solve.

== Logic
\ Syntax: What is an acceptable sentence
\ Semantics: What do the sentences and symbols mean?
\ Proof procedure: How to construct valid proofs?
\ Proof: Sequence of sentences derivable using an inference recursively

\ Statements/Premises: ${X}$ is a set of statements or premises, made up of propositions.
\ Interpretation: Set of truth assignments to propositions in ${X}$
\ Model: Interpretation that makes statements true
\ Inconsistent statements: No model exists
\ Logical Consequence: If for every model of ${X}$, A is true, then A is a logical consequence of ${X}$

*Argument Validity* is satisfied if any of the identical statements are true:
- Conclusions are a logical consequence of premises
- Conclusions are true in every model of premises
- No situation in which the premises are all true but the conclusions are false.
- Arguments $arrow.r$ conclusions is a *tautology* (always true)

== Proof
\ Knowledge Base: Set of axioms
\ Derivation: $"KB" tack "g"$ can be found from KB using proof procedure
\ Theorem: If $"KB" tack "g"$, then $g$ is a theorem
\ Sound: Proof procedure is sound if $"KB" tack "g then KB" models "g"$ (anything that can be proven must be true (sound reasoning))
\ Complete: Proof procedure is sound if $"KB" models "g then KB" tack "g"$ (anything that is true can be proven (complete proof system))

\ Complete Knowledge: Assume a closed world where *negation* implies failure since we can't prove it, if it's open there are true things we don't know, so if we can't prove something, we can't decide if it's true or false.

== Bottom-up Proof (aka forward chaining)
Start from facts and use rules to generate all possible derivable propositions

To prove: $F arrow.l A and E$
$A arrow.l B and C$
$A arrow.l D and C$
$E arrow.l C$
$D$
$C$

Steps of proof: ${D, C} arrow {D, C, E} arrow {D, C, E, A} arrow {D, C, E, A, F}$
Therefore, if g is an atom, KB $tack$ g, if g $in C$ at the end of the procedure, where $C$ is the consequence set.

== Top-Down
Start from query and work backwards
yes $arrow.l F$
yes $arrow.l A and E$
yes $arrow.l D and C and E$
yes $arrow.l D and C and C$
yes $arrow.l D and C$
yes $arrow.l D$
yes $arrow.l$

=== Individuals and Relations
KB can contain *relations*: part_of(C, A) is true if C is a "part of" A
KB can contain *quantification*: part_of(C, A) holds $forall C, A$
Proofs are the same with extra bits for handling relations & quantification.

== Planning
Decide sequence of actions to solve goal based on abilities, goal, state of the world
Assumptions:
- Single agent
- Deterministic
- No exogenous events
- Fully-observable state
- Time progresses discretely from one state to another
- Goals are predicates of states to achieve or maintain (no complex goals)

\ Action: Partial function from state to state
\ Partial Function: Some actions are not possible in some states, preconditions specify when action is valid, and effect determines next state

== State Representations

\ Feature-based representation of actions: For each action, there is a precondition (proposition) that specifies when action is valid and a set of consequences for features after action.
\ State-based representation: For each possible assignment of features, define a state. Then for each action define the starting and ending state for the state-based graph.

\ Causal Rule: When feature gets a new value
\ Frame Rule: When feature keeps its value
_Features are capitalized, but values aren't_
_If X is a feature, X' is feature after an action_

\ Forward Planning: Search in state-space graph, where nodes are states, arcs are actions, and a plan is a path representing initial state to goal state.
\ Regression Planning: Search backwards from goal, nodes correspond to subgoals and arcs to actions. Nodes are propositions (formula made of assignment of values to features), arcs are actions that can achieve one of the goals. Neighbors of node N associated with arc specify what must be true immediately before A so that N is true immediately after. Start node is goal to be achieved. Goal(N) is true if N is a proposition true of initial state.