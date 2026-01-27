= Reinforcement Learning

Given prior knowledge (possible states of world, possible actions), observations (current state, immediate reward/punishment), and a goal (act to maximize accumulated reward), how do you proceed?

- Given sequence of experiences (state, action, reward, state, action, reward, ...), how do you determine what to do next.
- You must either decide to explore to gain more knowledge, or exploit knowledge you've already discovered.

Difficulties of reinforcement learning:
/ Credit Assignment Problem: What actions are responsible for reward? Reward may have occurred a long time after action that caused it.
- Long term effect of action of agent depends on what it will do in future, but we don't have a model to predict this.
/ Explore-Exploit Dilemma: At each time should the robot be greedy or inquisitive?

Main Approaches:
- Model-Free RL: learn $Q^* (s, a)$ and use this to guide action
- Model-Based RL: Learn a model consisting of state transition function $P(s prime|a, s)$ and reward function $R(s, a, s prime)$ and solve this as an MDP.
- Search through space of policies

=== Running Average Value
Suppose we have values $v_1, v_2, v_3, dots$, a running average could be $A_k = (v_1 + dots + v_k)/k$. With new value $v_k$, we can re-write this as $A_k = (k-1)/k A_(k-1) + v_k/k$. If we let $alpha = 1/k$ then we simplify to $A_k = (1 - alpha)A_(k-1) + alpha v_k = A_(k-1) + alpha (v_k - A_(k-1))$
This is called the *TD Formula* for temporal difference. We often use this update with $alpha$ fixed.

== Q-Learning
Goal: Store Q[State, Action] and update this as in asynchronous value iteration, but using experience (empirical probabilities and rewards)
- Suppose this agent has an experience $angle.l s, a, r, s prime angle.r$, that's one piece of data to update Q[s, a]
- The experience $angle.l s, a, r, s prime angle.r$ provides data point $r + gamma max_(a prime) Q[s prime, a prime]$
- Plugged into TD formula gives: $Q[s, a] arrow.l Q[s, a] + alpha(r + gamma max_(a prime) Q[s prime, a prime] - Q[s, a])$

Procedure:
+ Initialize Q[S, A] arbitrarily
+ Observe current state $s$
+ repeat forever
  + select and carry out an action a
  + Observe reward r and state $s prime$
  + $Q[s, a] arrow.l Q[s, a] + alpha (r + gamma max_(a prime) Q[s prime, a prime] - Q[s, a])$
  + $s arrow.l s prime$

Properties:
- Q-learning convergences to optimal policy. No matter what agent does as long as it tries each action in each state enough (infinitely often)
- Exploit: When in state $s$, select action that maximizes $Q[s, a]$
- Explore: Select another action

=== Exploration Strategies
- $epsilon.alt$-greedy: Choose a random action with probability $epsilon.alt$ and choose best action with probability $1 - epsilon.alt$
- Softmax action selection: In state $s$, choose action $a$ with probability $(e^(Q[s, a]/tau))/(sum_a e^Q[s, a]/tau)$ where $tau > 0$ is temperature. Good actions are chosen more often than bad actions, and $tau$ defines how often good actions are chosen. For $tau arrow infinity$, all actions are equiprobable. For $tau arrow 0$, only the best is chosen.
- Optimism in face of uncertainty: Initialize $Q$ to values that encourage exploration
- Upper Confidence Bound: Also store $N[s, a]$ (number of times that state-action pair has been tried) and use $arg max_a [Q(s, a) + k sqrt((N[s])/(N[s, a]))]$ where $N[s] = sum_a N[s, a]$

=== Off/On-policy learning
- Q-learning does off-policy learning: It learns value of optimal oplicy, no matter what it does
- This could be bad if exploration policy is dangerous
- On-policy learning learns the value of the policy being followed (e.g. act greedily 80% of time and act randomly 20% of time)
- If agent is actually going to explore, it would be better to optimize the actual policy it is going to do
- SARSA uses experience $angle.l s, a, r, s prime, a prime angle.r$ to update $Q[s, a]$
- SARSA is on-policy because it uses empirical values for $s prime$ and $a prime$

SARSA procedure:
+ Initialize Q[S, A] arbitrarily
+ Observe current state $s$
+ Select action $a$ using a policy based on $Q$ including exploration
+ Repeat forever:
  + Carry out action $a$
  + Observe reward $r$ and state $s prime$
  + Select action $a prime$ using a policy based on $Q$
  + $Q[s,a] arrow.l Q[s, a] + alpha(r + gamma Q[s prime, a prime] - Q[s, a])$
  + $s arrow.l s prime$
  + $a arrow.l a prime$

=== Model-based Reinforcement Learning
- Model-based RL uses experiences in a more effective manner
- It is used when collecting experiences is expensive (e.g. in robot or online game) and you can do lots of computation between each experience
- Idea: Learn MDP and interleave acting and planning
- After each experience, update probabilities and reward, then do some steps of asynchronous value iteration

Procedure:
- Data structures: Q[S, A]; T[S, A, S], R[S, A]
+ Assign Q, R arbitrarily, T = prior counts
+ $alpha$ is learning rate
+ observe current state $s$
+ Repeat:
  + Select and carry out action a
  + Observe reward $r$ and state $s prime$
  + $T[s, a, s prime] arrow.l T[s,a, s prime] + 1$
  + $R[s, a,] arrow.l alpha times r + (1 - alpha) times R[s, a]$
  + Repeat for a while (asynchronous value iteration):
    + select state $s_1$ action $a_1$
    + Let $P = sum_(s_2) T[s_1, a_1, s_2]$
    + $Q[s_1, a_1] arrow.l sum_(s_2) (T[s_1, a_1, s_2])/P (R[s_1, a_1] + gamma max_(a_2) Q[s_2, a_2])$
  + $s arrow.l s prime$

=== Q-Function Approximations
Let $s = (x_1, x_2, dots, x_n)^top$, where $x$ are features
- Linear approximation: $Q_w(s, a) approx sum_i w_(a i) x_i$
- Non-linear (e.g. neural network g): $Q_w(s, a) approx g(x; w_a)$

==== Logistic Regression
Logistic function of linear weighted inputs: $hat(Y)^(overline(w))(e) = f(w_0 + w_1 X_1(e) + dots + w_n X_n(e)) = f(sum^n_(i=0) w_i X_i(e))$

Sum of squares error is $"Error"(E, overline(w)) = sum_(e in E)[Y(e) - f(sum^n_(i=0) w_i X_i(e))]^2$

Partial derivative with respect to weight $w_i$ is $(partial "Error"(E, overline(w)))/(partial w_i) = - 2 delta f prime(sum_i w_i X_i (e)) X_i (e)$ where $delta = (Y(e) - f(sum^n_(i=0) w_i X_i (e)))$

Therefore each example $e$ updates each weight $w_i$ by $w_i arrow.l w_i + mu delta f prime (sum_i w_i X_i (e)) X_i (e)$

==== Approximating Q-Function
- Assign weights $w = overline(w) = angle.l w_0, dots, w_n angle.r$ arbitrarily
- for experience tuple $angle.l s, a, r, s prime, a prime angle.r$ we have:
  - target Q-function: $[R(s) + gamma max_a Q_(overline(w))(s prime, a)]$ or $[R(s) + gamma Q_(overline(w))(s prime, a prime)]$
  - Current Q-function: $Q_w (s, a)$

Squared Error: $"Err"(w) = 1/2 [Q_w(s, a) - R(s) - gamma max_(a prime) Q_(overline(w)) (s prime, a prime)]^2$

Gradient: $(partial "Err")/(partial w) = [Q_w(s, a) - R(s) - gamma max_(a prime) Q_(overline(w))(s prime, a prime)] (partial Q_w (s, a))/(partial w)$

Weight Update: $w arrow.l w - alpha (partial "Err")/(partial w)$

Occasionally: $overline(w) arrow.l w$

==== SARSA with linear function approximation
Given $gamma$ as discount factor and $alpha$ as learning rate

+ Assign weights $overline(w) = angle.l w_0, dots, w_n angle.r$ arbitrarily
+ Observe current state $s$
+ Select action $a$
+ Repeat forever
  + Carry out action $a$
  + Observe reward $r$ and state $s prime$
  + Select action $a prime$ (using a policy based on $Q_(overline(w))$)
  + let $delta = r + gamma Q_(overline(w))(s prime, a prime) - Q_w (s, a)$
  + For i = 0 to n
    + $w_i arrow.l w_i + alpha times delta times (partial Q_w (s, a))/(partial w_i)$
  + $s arrow.l s prime$ and $a arrow.l a prime$ and sometimes $overline(w) arrow.l w$

===== Convergence
Linear Q-Learning converges under same conditions as Q-learning ($w_i arrow.l w_i + alpha[Q_w (s, a) - R(s) - gamma Q_w(s prime, a prime)] x_i$)

Non-linear Q-learning may diverge. Adjusting $w$ to increase $Q$ at $(s, a)$ might introduce errors at nearby state-action pairs. 

===== Mitigating Divergence
+ Experience Replay
  - Idea: Store previous experiences $(s, a, r, s prime, a prime)$ in a buffer and sample a mini-batch of previous experiences at each step to learn by Q-learning
  - Breaks correlations between successive updates for more stable learning
  - Few interactios with environment are needed to converge, which increases data efficiency
+ Use two $Q$ functions: Q network (currently being updated) and Target network (occasionally updated)
  - Idea: Use separate target network updated only periodically
  - Target network has weights $overline(w)$ and computes $Q_(overline(w))(s, a)$
  - Repeat for each $(s, a, r, s prime, a prime)$ in a mini-batch:
    - $w arrow.l w + alpha [Q_w(s, a) - R(s) - gamma Q_(overline(w))(s prime, a prime)] (partial Q_w (s, a))/(partial w)$
  - $overline(w) arrow.l w$

Deep Q-Network:
+ Assign weights $overline(w) = angle.l w_0, dots, w_n angle.r$ at random in $[-1, 1]$
+ Observe current state $s$
+ Select action $a$
+ Repeat
  + Carry out action $a$
  + Observe reward $r$ and state $s prime$
  + Select action $a prime$ (using a policy based on $Q_overline(w))$)
  + Add $(s, a, r, s prime, a prime)$ to experience buffer
  + Sample mini-batch of experiences from buffer
  + For each experience $(hat(s), hat(a), hat(r), hat(s prime), hat(a prime))$ in mini-batch:
    + Let $delta = hat(r) + gamma Q_(overline(w))(hat(s prime), hat(a prime)) - Q_w (hat(s), hat(a))$
    + $w arrow.l w + alpha times delta times (partial Q_w (hat(s), hat(a)))/(partial w)$
  + $s arrow.l s prime$ and $a arrow.l a prime$
  + every $c$ steps, update target $overline(w) arrow.l w$

=== Policy search using policy gradient
- Instead of approximating $Q$, we can also approximate policy $pi$
- $pi(a | s)$ is now a function that maps state $s$ to a distribution over actions $a$
- Let $s = (x_1, dots, x_n)^top$
- Linear: $Q_w (s, a) approx sum_i w_(a i) x_i$, $pi_theta (a | s) approx sum_i theta_(a i) x_i$
- Non-linear (neural networks) $Q_w(s, a) approx g(x; w_a)$, $pi_theta(a | s) approx g(x; theta_a)$

To change parameters $theta$ of policy $pi_theta$, consider $V, Q$ to be value functions under $pi_theta$. $d^pi(s) = lim_(t arrow infinity P(s_t = s|s_0, pi_theta))$ is the stationary distribution of Markov chain for $pi_theta$

Our objective to maximize is $J(theta) = sum_(s in S) d^pi(s) V(s) = sum_(s in S) d^pi(s) sum_(a in A) pi_theta (a | s) Q(s, a)$

==== Policy Gradient Theorem
- Finding a gradient is difficult because it depends on both action selection $pi_theta$ and state distribution $d(s)$ but updating policy changes the state distribution. But policy gradient theorem allows us to simplify gradient.

$
gradient_theta J(theta) &= gradient_theta sum_(s in S) d^pi(s) sum_(a in A) pi_theta (a | s) Q(s, a) \
&approx sum_(s in S) d^pi(s) sum_(a in A) Q(s, a) gradient_theta pi_theta (a | s) \
&= sum_(s in S, a in A) d^pi(s) pi_theta(a | s) Q(s, a) (gradient_theta pi_theta(a | s))/(pi_theta(a | s)) \
&= EE_pi [Q(s, a) gradient_theta ln pi_theta(a | s)]
$ where $EE_pi$ refers to $EE_(s tilde d^pi, a tilde pi_theta)$ where both state and action distributions follow the policy (on policy)

==== REINFORCE algorithm
- Use sampled trajectories to compute expectation over $Q(s, a)$
$
gradient_theta J(theta) &approx EE_pi[Q(s, a) gradient_theta ln pi_theta(a | s)] \
&= EE_pi [(sum^infinity_(k=0) gamma^k r_(t+k+1)) gradient_theta ln pi_theta (a_t | s_t)]
$

+ Initialize $theta$ to random
+ Sample one trajectory using $pi_theta$: $s_1, a_1, r_2, s_2, a_2, dots, s_T$
+ For $t = 1, 2, dots, T$
  + Estimate $G_t = sum^(T-t-2)_(k=0) gamma^k r_(t+k+1)$
  + Update $theta arrow.l theta + alpha gamma^t G_t gradient_theta ln pi_theta(a_t | s_t)$

The algorithm samples trajectories to estimate gradient results in high variance. The goal is to subtract a baseline value from return $G_t$ to reduce variance of gradient estimation. You can also use *Advantage* $A(s_t, a_t) = Q(s_t, a_t) - V(s_t)$ instead of $G_t$

==== Actor-Critic
- Learn two models, Actor $pi_theta$ and critic $Q_w$
- $alpha$ and $beta$ are learning rates
- Use actor to update $pi_theta(a | s)$ in direction suggested by critic.

#image("../assets/actor-critic.png")

==== Bayesian Reinforcement Learning
- Include parameters (transition function and observation function) in state space
- Model-based learning through inference (belief state)
- State space is now continuous, belief space is a space of continuous functions
- Can mitigate complexity by modeling reachable beliefs
- Optimal exploration-exploitation tradeoff