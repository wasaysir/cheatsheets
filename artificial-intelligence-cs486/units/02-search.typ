#import "@preview/lovelace:0.3.0": *

= Search
$b$ is branching factor (max num children of any node) \
$m$ is max depth of search-tree \
$d$ is depth of shallowest goal node \

*Search Problem*: 
- Set of states
- Initial state
- Goal function
- Successor function
- (optional) cost

*Frontier*: Ends of paths from start node that have been explored

== Graph Search Algorithm
#pseudocode-list[
  + frontier is just start node
  + *while* frontier isn't empty
    + select and remove path $angle.l n_0, dots, n_k angle.r$ from frontier
    + *if* goal($n_k$) *then*
      + return $angle.l n_0, dots, n_k angle.r$
    + *for each* neighbor $n$ of $n_k$ do
      + *add* $angle.l n_0, dots, n_k, n angle.r$
]

== Uninformed Search
=== Depth-first-search
Use frontier as stack, always select last element
*Cycle Check*: Check if current node exists within path you are Checking
*Space Complexity*: $O(b m)$
*Time Complexity*: $O(b^m)$
*Completeness*: No
*Optimal*: No

Use:
- Restricted space
- Many solutions with long paths
Don't use:
- Infinite paths exist
- Optimal solutions are shallow
- Multiple paths to node

=== Breadth-first-search
Use frontier as queue, always select first element
*Multiple-Path Pruning*: Check if current node has been visited by any previous path by maintaining explored set.
*Space Complexity*: $O(b^d)$
*Time Complexity*: $O(b^d)$
*Completeness*: Yes
*Optimal*: No (only finds shallowest goal node)

Use:
- Space isn't restricted
- Want shallowest arc
Don't use:
- All solutions are deep
- Problem is large and graph is dynamically generated

=== Iterative-Deepening
For every depth-limit, perform depth-first-search, this marries BFS and DFS by "doing BFS" but without space-concerns. However, we end up revisiting nodes.

*Space Complexity*: $O(b d)$ 
*Time Complexity*: $O(b^d)$, $b^d sum^d_(n=1) n (1/b)^(n-1) = b^d (b/(1-b))^2$ We visit level $i$ $d - i$ times, and level $i$ has $b^i$ nodes, so that's the sum, then extending to infinity, and use geometric series.
*Completeness*: Yes
*Optimal*: No (only finds shallowest goal node)

Use:
- Space isn't restricted
- Want shallowest arc
Don't use:
- All solutions are deep
- Problem is large and graph is dynamically generated

=== Lowest-Cost-First-Search
Select a path on frontier with lowest cost. Frontier is priority queue ordered by path cost.
_Technically uninformed/blind search because it's searching randomly_
*Space Complexity*: $O(b^d)$
*Time Complexity*: $O(b^d)$
*Completeness and optimality*: Yes if branching factor is finite and cost of every edge is strictly positive.
*Termination*: Only terminate when the goal node is first on the frontier, not if it's in the frontier.

=== Dijkstra's
Similar to LCFS but keep track of lowest cost to reach each node, if we find lower cost path, update that value and resort the priority queue. 
Ex: Suppose we have path in frontier $angle.l P, Q, R, angle.r$ and the found path to Q is 10 and overall cost is 12, then we find a new path to $Q$ of cost 9, then we should recompute path to get cost 11.

== Heuristic Search
$h(n)$ is estimate of cost of shortest path from $n$ to a goal node.
Should only use readily obtainable information and be *much* easier than solving the problem.

=== Greedy Best-First Search
Select path whose end is closest to a goal based on heuristic. Frontier is a priority queue ordered by $h$.
*Space Complexity*: $O(b^d)$
*Time Complexity*: $O(b^d)$
*Completeness and optimality*: Not guaranteed (could be stuck in a cycle or return sub-optimal path)

=== Heuristic Depth-First-Search
Do Depth-First-Search, but add paths to stack ordered according to $h$. Basically, do DFS, but sort the children by $h$ to determine who to check.
Same complexity and problems as DFS but used often.

=== A\* search
Use both path cost and heuristic values. Frontier is sorted by $f(p) = "cost(p)" + h(p)$. Always selects node with lowest estimated distance.

*Space Complexity*: $O(b^d)$
*Time Complexity*: $O(b^d)$
*Completeness and optimality*: Only with admissable heuristic, finite branching factor, and bounded arc-costs (there is a minimum positive arc-cost).
A\* always expands the fewest nodes for all optimal algorithms and use the same heuristic. No algorithm with same info can do better. This is because if an algorithm does not expand all nodes with $f(n) < "cost"(s, g)$ they might not find the optimal solution. 

=== Admissable Heuristic
Never overestimates the shortest path from $n$ to goal node. 

*Procedure for construction*:
1. Define relaxed problem by simplifying or removing constraints
2. Solve relaxed problem without search
3. Cost of optimal solution to relaxed problem is admissable heuristic for original problem.

=== Dominating Heuristic
Given two heuristics, $h_2(n)$ dominates $h_1(n)$ if $forall n h_2(n) gt.eq h_1(n)$ and $exists n h_2(n) gt h_1(n)$
We prefer dominating heuristics because it reduces the nodes we have to expand (they're bigger, so we don't care)

=== Monotone Restriction
A\* guarantees finding optimal goal, but not necessarily shortest path. In order to do that, we would want our estimate path $f(p)$ to indeed allow us to remove longer paths, but what if one path has shorter cost, but heuristic sums make the shorter path have larger $f(p)$? We can avoid that, by inducing monotonic restriction. $h(n') - h(n) lt.eq "cost"(n', n)$. This guarantees heuristic estimate is always less than actual cost and if we ever find a shorter estimate, that estimate will actually be shorter, so we can prune it. 

Further, monotonic restriction with multi-path pruning always finds shortest path to goal, not just optimal goal itself.

Note that admissability guarantees heuristic is never bigger than shortest path to goal, monotonicity ensures heuristic is never bigger than shortest path to any other node.

=== Summary
#table(
    columns: 5,
    table.header(
        [Strategy],
        [Frontier Selection],
        [Halt?],
        [Space],
        [Time]
    ),
    [Depth-first], [Last node added], [No], [Linear], [Exp],
    [Breadth-first], [First node added], [Yes], [Exp], [Exp],
    [Heuristic Depth-first], [Local min $h(n)$], [No], [Linear], [Exp],
    [Best-first], [Global min $h(n)$], [No], [Exp], [Exp],
    [Lowest-cost-first], [min $"cost"(n)$], [Yes], [Exp], [Exp],
    [A\*], [min $f(n)$], [Yes], [Exp], [Exp],
)

=== Adversarial Search (Minimax)
For one node look to maximize the heuristic, for the other node look to minimize it (to simulate the adversarial search)

- Alpha-beta pruning can ignore portions of search tree without losing optimality. Useful in application but doesn't change asymptotics
- Can stop early by evaluating non-leafs via heuristics (doesn't guarantee optimal play)

=== Higher-level strategies
- *Bidirectional Search*: Search from backward and forward simultaneously taking $2b^(k/2)$ vs $b^k$ and try to find where frontiers match
- *Island-driven Search*: Find set of islands between $s$ and $g$ as mini problems. With $m$ islands, you get $m b^(k/m)$ vs $b^k$ but it's harder to guarantee optimality.
