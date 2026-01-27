= Planning with Uncertainty

== Bayesian Decision Making
$EE(V("decision")) = sum_"outcome" P("outcome" | "decision") V("outcome")$

You can expand this to include context, so $V("decision, context")$ is value of decision in situation context.

$EE(V("decision, context")) = sum_"outcome" P("outcome" | "decision, context") V("outcome")$

== Preferences
- Actions result in outcomes
- Agents have preferences over outcomes
- (Decision-theoretic) rational agents will do action that has best outcome for them
- Sometimes agents don't know outcomes of the actions, but they still need to compare actions
- Agents have to act (doing nothing is often a meaningful action)

=== Preferences over outcomes
- If $o_1$ and $o_2$ are outcomes
- $o_1 succ.eq o_2$ iff $o_1$ is at least as desirable as $o_2$ (weak preference)
- $o_1 tilde o_2$ means $o_1 succ.eq o_2$ and $o_2 succ.eq o_1$ (indifference)
- $o_1 succ o_2$ means $o_1 succ.eq o_2$ and $o_2 succ.neq o_1$ (strong preference)

/ Lottery: Probability Distribution over outcomes written $[p_1: o_1, p_2: o_2, dots, p_k: o_k]$

=== Preference Properties
- Completeness: Agents have to act, so they must have preferences. $forall o_1 forall o_2, o_1 succ.eq o_2 "or" o_2 succ.eq o_1$
- Transitivity: If $o_1 succ.eq o_2$ and $o_2 succ.eq o_3$, then $o_1 succ.eq o_3$
- Monotonicity: Agent prefers larger chance of getting better outcome than smaller chance. If $o_1 succ o_2$ and $p > q$, then $[p: o_1, 1-p: o_2] succ [q: o_1, 1 - q: o_2]$
- Continuity: Suppose $o_1 succ o_2$ and $o_2 succ o_3$, then there exists $p in [0, 1]$ such that $o_2 tilde [1 - p: o_1, p:o_3]$
- Decomposability: Agent is indifferent between lotteries that have same probabilities and outcomes. (Expected value is the only thing that matters, risk is irrelevant)
- Substitutability: If $o_1 tilde o_2$ then agent is indifferent between lotteries that only differ by $o_1$ and $o_2$

/ Utility Function Theorem: If preferences follow preceding properties, then preferences can be measured by a function $"utility": "outcomes" arrow [0, 1]$ such that $o_1 succ.eq o_2$ if and only if $"utility"(o_1) gt.eq "utility"(o_2)$ and utilities are linear with probabilities so $"utility"([p_1: o_1, dots, p_k: o_k]) = sum^k_(i=1) p_i times "utility"(o_i)$

/ Rational agents: Act to maximize expected utility

=== Making decisions under uncertainty
- Agents should choose based on their abilities (what options are available), beliefs (way the world could be given agent's knowledge), and preferences (what agent wants and tradeoffs when there are risks)

=== Single Decisions
/ Decision Variables: Similar to random variables that agent gets to choose value of. In single variable, agent can choose $D = d_i$ for any $d_i in "dom"(D)$
- Expected utility of decision $D = d_i$ leading to outcomes $omega$ for utility function $u$ is $EE(u | D=d_i) = sum P(omega | D=d_i) u(omega)$
/ Optimal Single Decision: $D = d_"max"$ whose expected utility is maximal, $EE(u | D=d_"max") = max_(d_i in "dom"(D)) EE(u|D=d_i)$

=== Decision Networks
/ Decision network: Graphical representation of finite sequential decision problem. They extend belief networks to include decision variables and utility. Decision network specifies what information is available when agent has to act and which variables utility depends on.

- Random variables are drawn as ellipses. Edges into node represent probabilistc dependence.
- Decision variables are drawn as rectangles. Edges represent information available when decision is made.
- Utility node is drawn as diamond. Edges into it represent variables that utility depends on.

==== Finding Optimal Decision
Suppose random variables are $X_1, dots, X_n$, decision variables are $D$, and utility depends on $X_(i_1), dots, X_(i_k)$ and $D$. Then, expected utility is: $EE(u | D) = sum_(X_1, dots, X_n) P(X_1, dots, X_n|D) times u(X_(i_1), dots, X_(i_k)), D) = sum_(X_1, dots, X_n) [product^n_(j=1) P(X_j | "parents"(X_j))] times u(X_(i_1), dots, X_(i_k), D)$ 

To find optimal decision:
+ Create factor for each conditional probability and for utility.
+ Multiply together and sum out all of the random variables
+ This results in a factor on $D$ that gives expected utility for each $D$
+ Choose $D$ with maximum value in factor.

=== Sequential Decisions
An agent typically doesn't do multiple stpes all at once without trying to gather more information; more common situation is (observe, act, observe, act, ...). Subsequent actions depend on observations, which depend on previous actions. 

/ Sequential Decision Problem: Sequence of decision variables $D_1, dots, D_n$
- Each $D_i$ has information set of variables parents($D_i$) whose value will be known at the time decision $D_i$ is made.

=== Policies
/ Policy: Sequence $delta_1, dots, delta_n$ of decision functions: $delta_i: "dom"("parents"(D_i)) arrow "dom"(D_i)$ which means that when agent has observed $O in "dom"("parents"(D_i))$ it will do $delta_i(O)$

A possible world $omega$ satisfies policy $delta$ (written $omega models delta$) if decisions of policy are those the world assigns to decision variables. That is, each world assigns values to the decision nodes that are the same as in the policy.

/ Expected Value of policy $delta$: $EE(u | delta) = sum_(omega models delta) u(omega) times P(omega)$
/ Optimal Policy: Policy that maximizes expected utility

==== Finding Optimal Policy
+ Create factor for each conditional probability table and a factor for the utility
+ Set remaining decision nodes (which are all decision nodes)
+ Multiply factors and sum out random variables that aren't parents of a remaining decision node.
+ Select and remove a decision variable D from the list of remaining decision nodes. Pick one that is in a factor with only itself and some of its parents (no children)
+ Eliminate $D$ by maximizing to return optimal decision function for $D, arg max_D f$ and a new factor to use, $max_D f$
+ Repeat 3-5 until there are no more remaining decision nodes.
+ Eliminate remaining random variables. Multiply the factors: this is the expected utility of the optimal policy
+ If any nodes were in evidence, divide by $P("evidence")$

=== Agents
Agents carry out actions, forever (infinite horizon), until stopping criteria (indefinite horizon), finite and fixed number of steps (finite horizon)

/ Decision Theoretic Planning: What should agent do for various planning horizons when:
- It gets rewards and punishments and tries to maximize its rewards
- Actions are noisy, and outcome can't be fully predicted
- Model specifies probabilistic outcome of actions
- World if fully observable

/ World State: Information such that if you knew world state, no information about past is relevant to the future.
- If $S_i, A_i$ are state and action at time $i$, then $P(S_(t+1) | S_0, A_0, dots, S_t, A_t) = P(S_(t+1) | S_t, A_t)$
- Dynamics are *stationary* if distribution is same for each time point. $P(S_(i+1) | S_i, A_i) = P(S_(j+1) | S_j, A_j) forall i, j$

/ Absorbing States: State that once entered, can't be left (ex. lose virginity)

/ Markov Decision Process: Augmented Markov chain with actions and values
#image("../assets/markov-decision-process.png")

For MDP specify:
- Set $S$ of states
- Set $A$ of actions
- $P(S_(t+1) | S_t, A_t)$ to specify dynamics
- $R(S_t, A_t, S_(t+1))$ to specify reward. Agent gets reward at each time step (rather than final reward). 

=== Information Availability
/ Fully-Observable MDP: Agent gets to observe $S_t$ when deciding on action $A_t$
/ Partially-observable MDP (POMDP): Agent has some noisy sensor of the state. It is necessary to remember sensing and acting history (since it doesn't have full account of state, which it can accomplish by maintaining a sufficiently complex belief state) 

=== Rewards and Values
If agent receives sequence of rewards $r_1, r_2, dots$:
/ Total Reward: $V = sum^infinity_(i=1) r_i$
/ Average Reward: $V = lim_(n arrow infinity) (r_1 + dots + r_n)/n$
/ Discounted Reward: $V = sum^infinity_(i=1) gamma^(i-1) r_i$ where $gamma$ is discount factor $0 lt.eq gamma lt.eq 1$

=== Policies
/ Stationary Policy: Function $pi: S arrow A$ where given state $s, pi(s)$ speciesi what action the agent following $pi$ will do.
/ Optimal Policy: Policy with maximum expected discounted reward

For fully-observable MDP with stationary dynamics and rewards with infinite or indefinite horizon, there is always an optimal stationary policy.

$Q^pi(s, a)$ where $a$ is action and $s$ is state is expected value of doing $a$ in state $s$, then following policy $pi$ for afterwards decisions.

$V^pi(s)$ where $s$ is state, is the expected value of following policy $pi$ in state $s$

$Q^pi$ and $V^pi$ can be defined mutually recursively.

$Q^pi = sum_(s') P(s'|a, s)(r(s, a, s') + gamma V^pi(s'))$
$V^pi(s) = Q^pi(s, pi(s))$

$Q^*(s, a)$ is $Q^pi(s, a)$ for the optimal policy.
$pi^*(s)$ is optimal action to take in state $s$
$V^*(s)$ is expected value of following optimal policy in state s.

$Q^pi = sum_(s') P(s'|a, s)(r(s, a, s') + gamma V^*(s'))$
$V^pi(s) = max_a Q^a(s, a)$
$pi^*(s) = arg max_a Q^* (s, a)$

=== Value Iteration
- t-step lookahead value function $V^t$ is expected value with $t$ steps to go
- Goal: Given an estimate of t-step lookahead value function, determine $t+1$-step lookahead value function

Procedure:
+ Set $V^0$ arbitrarily, $t = 1$
+ Compute $Q^t, V^t$ from $V^(t-1)$
  - $Q^t(s, a) = [R(s) + gamma sum_(s') Pr(s'|s, a)V^(t-1)(s')]$
  - $V^t(s) = max_a Q^t(s, a)$

The policy with $t$ stages to go is simply action that maximizes $pi^t(s) = arg max_a [R(s) + gamma sum_(s') Pr(s' | s, a) V^(t-1)(s')]$

- This value iteration approach is dynamic programming (since we solve looping back from $t$)
- This iteration convergeces exponentially fast (in $t$) to the optimal value function
- Convergence occurs when $norm(V^t(s) - V^(t-1)(s)) < epsilon (1-gamma)/gamma$ ensures $V^t$ is within $epsilon$ of optimal value. ($norm(X) = max{abs(x), x in X}$)

 
=== Asynchronous Value Iteration
Asynchronous Value Iteration: Instead of having to sweep through all states, you can update the value function for each state individually, which then converges to the optimal value function, if each state and action is visited infinitely often in the limit. You can then either store $V[s]$ or $Q[s, a]$

Procedure:
+ Repeat:
  + Select state $s$
  + $V[s] arrow.l max_a sum_(s') P(s' | s, a) (R(s, a, s') + gamma V[s'])$
  + Select action $a$ (e.g. using an exploration policy)

Alternative Procedure:
+ Repeat:
  + Select state $s$, action $a$
  + $Q[s, a] arrow.l sum_(s') P(s' | s, a) (R(s, a, s') + gamma max_(a') Q[s', a'])$

Markov Decision Processes Factored State:
- Represent $S = {X_1, dots, X_n}$ and $X_i$ are random variables
- For each $X_i$, and each action $a in A$, we have $P(X_i' | S, A)$
- Reward $R(X_1, dots, X_n) = sum_i R(X_i)$
- Do value iteration as usual, but only one variable at a time (e.g. variable elimination)

=== Partially Observable Markov Decision Processes
POMDPs are similar to MDP but some variables aren't observed. It is a tuple $angle.l S, A, T, R, O, Omega angle.r$

- S: Finite set of unobservable states
- A: Finite set of agent actions
- $T: S times A arrow S$: Transition Function
- $R: S times A arrow cal(R)$: Reward Function
- $O$ Set of Observations
- $Omega: S times A arrow O$: Observation Function

#image("../assets/partially-observable-mdp.png")

Value Functions: $V^(k+1)(b) = max_a (R^a(b) + gamma sum_o Pr(o | b, a) V^k(b^a_o))$
You can represent $V(b)$ as a piecewise linear function over the belief space—pieces are called $alpha$ vectors.

==== Policies
Map belief states into actions, $pi(b(s)) arrow a$
Two ways to compute:
1. Backwards search
  - Dynamic programming (Variable Elimination)
  - In MDP: $Q_t(s, a) = R(s, a) + gamma sum_(s prime) Pr(s prime | s, a) max_(a prime) Q_(t-1) (s prime, a prime)$
  - In POMDP: $Q_t(b(s), a)$
  - Point-based backups make this efficient
2. Forwards Search
  - Expand beliefs going forward
  - $b^a_o(s')$ is reached (from $b(s)$) after acting action $a$ and observing $o$ using Transition $T$ and observation $Omega$ functions
  - $b^a_o(s prime) = sum_(s in S) T(s prime | a, s) Omega(o | s prime, a) b(s) forall b in beta$
  - Can expand more deeply in promising directions
  - Ensure exploration using Monte-Carlo Tree Search

Forward Search for POMDP:
- For each action-observation pair $a, o$:
  - $b^a_o(s prime) arrow.l$ propagate $b(s)$ forwards for each action and observation using stochastic simulation/particle filter
  - if $b^a_o(s prime)$ not at a leaf:
    - Evaluate recursively by further growing the tree: $V^a_o arrow.l "GetValue"(b^a_o(s prime))$
  - Else:
    - Create new leaf for $a, o$
      - Do a series of single-belief point rollouts (e.g. propagate a single belief forward stochastically gathering reward until termination condition is met)
      - Use the total returned value as $V^a_o$
- Return $R(b(s)) + max_a{gamma sum_o P(o | b(s), a) sum_(s prime) V^a_o b^a_o (s prime)}$

=== Monte Carlo Tree Search
- Selection: Select node to visit based on tree policy
- Expansion: A new node is added to the tree upon selection
- Simulation: Run trial simulation based on a default policy (usually random) from newly created node until terminal node is reached
- Backpropagation: Sampled statistics from the simulated trial is propagated back up from the child node to the ancestor nodes

#image("../assets/monte-carlo-tree-search.png")