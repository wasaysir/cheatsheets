= Phylogeny
*MRCA*: Most Recent Common Ancestor
*Internal Nodes*: Ancient hypothetical species
*Leaf Nodes*: Extant species
*Neighbour*: Two species that are most closely related on tree
*Outgroup*:  
*Clade*: Group of organisms with common ancestor
*Outgroup*: Set of organisms that are not in the "ingroup", and are distant in the tree.
*Homolog*: Descendant of common ancestor
*Analog*: Similar but don't share ancestry
*Ortholog*: Speciation event, where common ancestors break into two species
*Paralog*: One gene breaks into two separate versions in same genome
*Phylogeny*: Construction of evolutionary tree by evolutionary relationship
*Morphology*: Construction of evolutionary tree by physical featuers

3 problems: *Topology*, *Root*, *Branch Lengths*

*Cladogram*: Tree where branch length has no meaning
*Phylogram*: Tree where branch length conveys genetic change
*Ultrametric tree*: Tree where branch length conveys time

*Hierarchical Clustering*: Arrange sequences based on pairwise distance in hierarchical manner

*Well-behaved tree*: All nodes have equal distance from root to leaves (ultrametric), the distance is defined as "time"

== Distance-based methods
=== UPGMA
*UPGMA*: Unweighted Pair Group Method with Arithmetic Mean

*Linkage Criterion*: Distance metric between two groups (not just sequences, but 2 separate groups of sequences)

Given distance matrix, find closest pair of species, then combine them to a "new node" and recalculate the values for it and the remaining sequences by $"UPGMA" = "Sum of pairwise distances" / "Number of pairs"$ and continue until you're done.

This best describes topology and distance of species.

=== Neighbour Joining
*Additive Matrix*: There exists an additive tree fitting the matrix
*Additive Tree*: Given symmetric $n times n$ 0-diagonal matrix, for any neighbouring leaves $i, j$, with parent $m$, the distance from $m$ to any other leaf $k$ is $d_(k, m) = (d_(i, k) + d_(j, k) - d_(j, l)) / 2$
*Four-Point Theorem*: Distance matrix is additive iff two of the sums are equal and third is less than or equal to other sums: 
#image("../assets/fourpoint.png")


==== Procedure
Create auxiliary matrix where $Q(i, j) = (n-2)d_(i, j) - sum_(k in L) d_(i, k) - sum_(k in L) d_(j, k)$. Then find elements with a minimum non-diagonal value. Then, let $Delta = ("Total Distance"(i) - "Total Distance"(j))/(n - 2)$, then $"limbLength"_i = 1/2 (D_(i, j) + Delta)$ and $"limbLength"_j = 1/2 (D_(i, j) - Delta)$
Then, add a new row/column to D, so that $D_(k, m) = D_(m, k) = 1/2 (D_(k, i) + D_(k, j) - D_(i, j))$ and remove rows $i$ and $j$ from D. Then repeat recursively and add to the graph as needed.

Given set of leaf nodes, for every pair, define new q-metric relative to other species, as $D_(i j) - (r_i + r_j), r_i = 1/(abs(L) - 2) sum_(k in L) d_(i k)$

Then, find the smallest q-metric and combine the two species to make a new internal node as average of the two.

=== Jukes-Cantor
Jukes-Cantor is a tool to recompute distances based on back-mutations for more accurate phylogenetic trees.

Assumptions: 
1. All nucleotide bases occur with equal probability
2. Ech base has equal probability of mutating into any other
3. Substitutions occur independently

Let $p_A(t), p_C(t), dots$ is probability that a given site contains nucleotide $A, C, dots$ at time $t$.

Since we assume all nucleotides are equally likely, $p_X(t)$ is probability that a site is $X (C, G, T)$ at time $t$

$sum_(delta in L) p_delta (t) = 1$ and if a nucleotide is $A$ at time $t = 0$, then $p_A(0) = 1, p_C(0) = p_G(0) = dots = 0$

Define mutation velocity away from $A$ as $alpha$, then mutaiton velocity from $A$ to $C$ is $alpha/3$, same with all other nucleotides.

For infinitesimal time step $d t$, $p_A(t + d t) = "probability of staying A" = p_A(t) dot (1 - alpha d t) + p_C(t) dot (alpha/3) d t + dots + p_T(t) dot (alpha/3) d t$

Similarly, $p_X(t + d t) = "probability of becoming C, G, or T" = p_X(t)(1 - alpha d t) + p_A(t) (alpha/3)d t + 2 p_X(t)(alpha/3)d t$

Taking the limit as $d t arrow 0$, $(d p_A)/(d t) = -(4 alpha)/3 p_A + alpha/3$ and $(d p_X)/(d t) = alpha/3 p_A - alpha/3 p_X$

Then we solve to get $p_A(t) = 1/4 + 3/4 e^(-(4 alpha)/3 t)$ and $p_X(t) = 1/4 - 1/4 e^(e^(- (4 alpha)/3 t))$

Thus, the expected number of substitutions per site is: $d = -3/4 ln(1 - 4/3 p)$ which is our new distance function. $p = 3P_x$ as the observed fraction of nucleotide differences between sequences, and $d$ is assumed to be $alpha t$

== Character-based Method
=== Maximum Parsimony
Score trees based on the minimum number of substitutions required to convey the found tree. 

*Pseudocode*:
Given tree and alignment column $u$, label interal nodes to minimize substitutions.
*Initialization*: Set $C = 0$ and root node $k = 2 N - 1$
*Iteration*: If $k$ is a leaf, set $R_k = {x_k(u)}$
If $k$ is an internal node with children $i, j$: 
If $R_i sect R_j eq.not nothing, "set" R_k = R_i sect R_j$
Else

Note that $x_k(u)$ means the u'th base pair for node $k$. Then, for internal nodes, you take the intersection as the list of possible values that wouldn't require a substitution. If there is nothing, then join them, so that you only require one substitution.

=== Maximum Likelihood
The likelihood of a tree $T$ with branch lengths $t$ and given sequence alignment is $L(T, t) = P(x_1, dots, x_n | T, t)$

We want to find the most likely tree given sequence alignments. 
Note, $L(x_1, x_2) = sum_X pi_X P(x_1 | X, t_1)P(x_2 | X, t_2)$

$pi_X$ is stationary probability of nucleotide $X$, $X$ is possible ancestral states at root. $P(x_i | X, t_i)$ is probability of transition from $X$ to $x_i$ in time $t_i$

*Pseudocode*:
*Initialization*: At each leaf node, define $L_i(X) = 1$ if $X = x_i$, 0 otherwise.
*Recursion*: For each internal node with children $i, j$ $L_k(X) = sum_(Y, Z)P(X arrow Y, t_i)L_i(Y) dot P(X arrow Z, t_j)L_j(Z)$
*Final Step*: $L(T) = sum_X pi_X L_("root")(X)$

=== Tree Space Search
*Stepwise Addition*: Start from minimum tree (3 taxa) and add taxa, then optimize topology. 
*Use starting tree*: A tree with all taxa but is less accurate. Either use a cheap method for construction or randomly create.

== Summary
#table(
  columns: 2,
  [
    [*Methods*, *Optimality criterion*],
    [Distance methods, Distance],
    [Maximum Parsimony, Parsimony],
    [Maximum Likelihood, Likelihood],
  ]
)

Note top-to-bottom is increasing accuracy and decreasing efficiency.