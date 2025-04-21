= Constraints
== Constraint Satisfaction Problems
- A set of variables
- Domain for each variable
- Two kinds of problems:
  - Satisfiability problems: Assignment satisfying hard constraints
  - Optimizatoin: Find assignment optimizing evaluation function (soft constraints)
- Solution is assignment to variables satisfying all constraints
- Solution is model of constraints

=== CSPs as graphs
Search spaces can be very large, path isn't important, only goal, and no set starting nodes make this bad idea
/ Complete Assignment:
Nodes: Assignment of value to all variables
Neighbors: Change one variable value
/ Partial Assignment:
Nodes: Assignment to first $k-1$ variables
Neighbors: Assignment to $k^"th"$ variable

== Constraints
- Can be *N-ary* (over sets of $N$ variables) (Ex: A + B = C involves is 3-ary for 3 vars)

=== Generate and Test
Exhaust every possible assignment of vars and test validity
=== Backtracking
Order all variables and evaluate constraints in order as soon as they are fixed. (Ex: $A = 1 and B = 1$ is inconsistent with $A eq.not B$ so go to last assigned variable and change its value)
=== Consistency
Represent constraints as network to determine how all variables are related.
/ Domain Constraint: Unary constraint on values in domain written $angle.l X, c(X) angle.r$ (Eg: $B, B eq.not 3$)
/ Domain Consistent: A node is domain consistent if no domain value violates any domain constraint, and a network is domain consistent if all nodes are domain consistent.
/ Arc: Arc $angle.l X, c(X, Y) angle.r$ is a constraint on $X$
/ Arc Consistent: Arc $angle.l X, c(X, Y) angle.r$ is arc consistent if for every valid x there is a valid y such that constraint is satisfied.
/ Path Consistent: A set of variables is path consistent if all arcs and domains are consistent.

=== AC-3
Make Consistency network arc consistent
- To-Do Arcs Queue contains all inconsistent arcs
- Make all domains domain consistent
- Put all arcs in TDA
- Repeat until TDA is empty:
  - Select and remove an arc from TDA
  - Remove all values of domain of X that don't have value in domain of Y that satisfy constraint
  - If any were removed, add all arcs to TDA

*Termination*:
- If every domain is empty, no solution
- If every domain has a single value, solution
- If some domain has more than one value, split in two run AC-3 recursively on two halves
- Guaranteed to terminate
- Takes $O(c d^3)$ time, with $n$ variables, $c$ binary constraints, and max domain size is $d$ because each arc $angle.l X_k, X_i angle.r$ can be added to queue at most $d$ times because we can delete at most $d$ values from $X_i$. Checking consistency takes $O(d^2)$ time.

=== Variable Elimination
- Eliminate variables one-by-one passing constraints to neighbours. 
- When single variable remains, if no values exist then network was inconsistent.
- Variables are eliminated according to elimination ordering.

*Pseudocode*:
- If only one variable, return intersection of unary constraints referencing it
- Select variable $X$
  - Join constraints affecting X, forming constraint R
  - Project R onto its variables other than X, calling this R2
  - Place new constraint between all variables that were connected to X
  - Remove X
  - Recursively solve simplified problem
  - Return R joined with recursive solution

=== Local Search
- Maintain assignment of value to each variable
- At each step, select neighbor of current assignment
- Stop when satisfying assignment found or return best assignment found
- Heuristic function to be minimized: Number of conflicts
- Goal is an assignment with zero conflicts

=== Greedy Descent
Select some variable (through some method) and then select the value that minimizes the number of conflicts.
THe problem is that we could be stuck in a local minimum, without reaching the proper global minimum. 

=== Stochastic Local Search
Do Greedy descent, but allow some steps to be random, and the potential to restart randomly, to minimize potential for being stuck in local minimum.

Problem: in high dimensions often consist of long, nearly flat "canyons" so it's hard to optimize using local search.

=== Simulated Annealing
Pick variable at random, if it improves, adopt it. If it doesn't improve, then accept it with a probability through the temperature parameter, which can get slowly reduced.

=== Tabu Lists
Variant of Greedy Satisfiability, where to prevent cycling and getting stuck in local optimum, we maintain a "tabu list" of the k last assignments, and don't allow assignment that has already existed.

=== Parallel Search
- Total assignment is called individual
- Maintain population of $k$ individuals
- At each stage, update each individual in population
- Whenever individual is a solution, it can be reported
- Similar to $k$ restarts, but uses $k$ times minimum number of steps

=== Beam Search
- Like parallel search, with $k$ individuals, but choose the $k$ best out of all the neighbors. The value of $k$ can limit space and induce parallelism

=== Stochastic Beam Search
- Like beam search, but probabilistically choose $k$ individualls at next generation. Probability of selecting neighbor is proportional to heuristic: $e^(-h(n)/T)$. This maintains diversity among the individuals, because it's similar to simulated annealing. 

=== Genetic Algorithms
- Like stochastic beam search, but pairs of individuals are combined to create offspring. 
- For each generation, randomly choose pairs where fittest individuals are more likely selected
- For each pair, do cross-over (form two offspring as mutants of parents)
- Mutate some values
- Stop when solution is found

== Comparing Algorithms
Since some algorithms are super fast some of the time and super slow other times, and others are mediocre all of the time, how do you compare? You use runtime distribution plots to see the proportion of runs that are solved within a specific runtime.