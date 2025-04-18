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
This is called the *TD Formula*. We often use this update with $alpha$ fixed