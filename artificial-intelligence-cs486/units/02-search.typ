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
