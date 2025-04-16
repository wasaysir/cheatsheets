= Phylogeny
\ MRCA: Most Recent Common Ancestor (Root of Tree) \
\ Internal Nodes: Ancient hypothetical species 
\ Leaf Nodes: Extant species \
\ Neighbour: Two species that are most closely related on tree \
\ Clade: Group of organisms with common ancestor \
\ Outgroup: Set of organisms that are not in the "ingroup", and are distant in the tree. \
\ Homolog: Descendant of common ancestor \
\ Analog: Similar but don't share ancestry \
\ Ortholog: Speciation event, where common ancestors break into two species \
\ Paralog: One gene breaks into two separate versions in same genome \
\ Phylogeny: Construction of evolutionary tree by evolutionary relationship \
\ Morphology: Construction of evolutionary tree by physical featuers \

#image("../assets/ortholog-homolog-paralog.png")

3 problems: *Topology*, *Root*, *Branch Lengths*

\ Cladogram: Tree where branch length has no meaning
\ Phylogram: Tree where branch length conveys genetic change
\ Ultrametric tree: Tree where branch length conveys time

#image("../assets/tree-types.png")

\ Hierarchical Clustering: Arrange sequences based on pairwise distance in hierarchical manner \

\ Well-behaved tree: All nodes have equal distance from root to leaves (ultrametric), the distance is defined as "time". Also, the three-point condition is met, where for all distances, $x, y, z$, $d(x, y) lt.eq max(d(x, z), d(z, y))$ \

== Distance-based methods
=== UPGMA
\ UPGMA: Unweighted Pair Group Method with Arithmetic Mean

\ Linkage Criterion: Distance metric between two groups (not just sequences, but 2 separate groups of sequences)

#image("../assets/upgma-practice.png")
#image("../assets/upgma-merge.png")

Note that distance from node to leaf is half of distance value in the matrix.

Given distance matrix, find closest pair of species, then combine them to a "new node" and recalculate the values for it and the remaining sequences by $"UPGMA" = "Sum of pairwise distances" / "Number of pairs"$ and continue until you're done.

This best describes topology and distance of species.

Ultrametric trees are represented by symmetric 0-diagonal matrices, where indices represent divergence events. Given ultrametric matrix, an ultrametric tree for that matrix exists if:
- There are $n$ leaves, one for each row and column of matrix
- Each internal node is labeled by a time in $D$ and has exactly two-children
- Along any path from root to a leaf, the divergence times at the internal nodes strictly decrease.
- For any triplet of nodes, the distances $D_(i, j), D_(j, k), D_(i, k)$ are either equal, or two are equal and the remaining one is smaller. (By 4-point theorem)

=== Neighbour Joining
\ Additive Matrix: There exists an additive tree fitting the matrix \
\ Additive Tree: Given symmetric $n times n$ 0-diagonal matrix, for any neighbouring leaves $i, j$, with parent $m$, the distance from $m$ to any other leaf $k$ is $d_(k, m) = (d_(i, k) + d_(j, k) - d_(j, l)) / 2$ \
\ Four-Point Theorem: Distance matrix is additive iff two of the sums are equal and third is less than or equal to other sums: 
#image("../assets/fourpoint.png")

==== Procedure
#image("../assets/neighbour-joining-pseudocode.png")

Procedure:
+ Create auxiliary Q-matrix where $Q(i, j) = (n-2)d_(i, j) - sum_(k in L) d_(i, k) - sum_(k in L) d_(j, k)$. 
+ Merge closest pair wrt Q-matrix (lowest number in matrix)
+ Estimate branch length between chosen node and new node. $l(i, u) = 1/2 d(i, j) + 1/(2 (n-2)) [sum^n_(k=1) d(i, k) - sum^n_(k=1) d(j, k)]$. Note taht $l(i, u) + l(j, u) = d(i, j)$ Sometimes these branch lengths can be negative, so we can add a fixed constant to all branch lengths for non-negativity.
+ Update unrooted tree with new parent node between neighbours, and have respective lengths between them.
+ Update distance matrix so $d(u, k) = 1/2[d(i, k) + d(j, k) - d(i, j)]$

#image("../assets/neighbour-join-1.png")
#image("../assets/neighbour-join-2.png")
#image("../assets/neighbour-join-3.png")
#image("../assets/neighbour-join-4.png")
#image("../assets/neighbour-join-5.png")

=== Jukes-Cantor
Jukes-Cantor is a tool to recompute distances based on back-mutations for more accurate phylogenetic trees.

Assumptions: 
1. All nucleotide bases occur with equal probability
2. Each base has equal probability of mutating into any other with $r = 0.25$
3. Substitutions occur independently at each site over time

Let $p_A(t), p_C(t), p_G(t), p_T(t)$ be probabilities that a given site contains nucleotide $A, C, G, T$ at time $t$.

Since we assume all nucleotides are equally likely, $p_X(t)$ is probability that a site is $X (C, G, T)$ at time $t$

$sum_(delta in A,C,G,T) p_delta (t) = 1$ and if a nucleotide is $A$ at time $t = 0$, then $p_A(0) = 1, p_C(0) = p_G(0) = dots = 0$

Define total mutation velocity away from $A$ as $alpha$, then mutaiton velocity from $A$ to $C$ is $alpha/3$, same with all other nucleotides.

For infinitesimal time step $d t$, $p_A(t + d t) = "probability of staying A" = p_A(t) dot - p_A(t) alpha d t + (p_C(t) + p_G(t) + p_T(t)) dot (alpha/3) d t$

Similarly, $p_X(t + d t) = "probability of becoming C, G, or T" = p_X(t) - p_X(t)alpha d t + p_A(t) (alpha/3)d t + 2 p_X(t)(alpha/3)d t$

Taking the limit as $d t arrow 0$, $(d p_A)/(d t) = -(4 alpha)/3 p_A + alpha/3$ and $(d p_X)/(d t) = alpha/3 p_A - alpha/3 p_X$

Then we solve to get $p_A(t) = 1/4 + 3/4 e^(-(4 alpha)/3 t)$ and $p_X(t) = 1/4 - 1/4 e^(- (4 alpha)/3 t)$

Thus, the expected number of substitutions per site is: $d = -3/4 ln(1 - 4/3 p)$ which is our new distance function. $p = 3P_x$ is the observed fraction of nucleotide differences between sequences, and $d$ is assumed to be $alpha t$ to agree with $p$

== Character-based Method
=== Maximum Parsimony
Score trees based on the minimum number of substitutions required to convey the found tree. 

\ Parsimony: Simplest explanation is usually best.

*Pseudocode*:
Given tree and alignment column $u$, label interal nodes to minimize substitutions.
*Initialization*: Set $C = 0$ and root node $k = 2 N - 1$
*Iteration*: If $k$ is a leaf, set $R_k = {x_k(u)}$
If $k$ is an internal node with children $i, j$: 
If $R_i sect R_j eq.not nothing, "set" R_k = R_i sect R_j$
Else $R_k = R_i union R_j$ and increment $C$

To score a tree using maximum parsimony we do the following:
+ Assign nucleotide to root node:
  - Choose arbitrarily from $R_(2 N - 1)$
+ For each internal node $k$, assign nucleotides recursively
  - if parent $k$ has state $r$ and $r in R_i$, assign $r$ to descendant $i$
  - Otherwise choose arbitrarily from $R_j$

Note that $x_k(u)$ means the u'th base pair for node $k$. Then, for internal nodes, you take the intersection as the list of possible values that wouldn't require a substitution. If there is nothing, then join them, so that you only require one substitution.

#image("../assets/fitch-algorithm.png")

Note this doesn't build a tree, but scores it.

=== Maximum Likelihood
The likelihood of a tree $T$ with branch lengths $t$ and given sequence alignment is $L(T, t) = P(x_1, dots, x_n | T, t)$

We want to find the most likely tree given sequence alignments. 
Note, $L(x_1, x_2) = sum_X pi_X P(x_1 | X, t_1)P(x_2 | X, t_2)$

$pi_X$ is stationary probability of nucleotide $X$, $X$ is possible ancestral states at root. $P(x_i | X, t_i)$ is probability of transition from $X$ to $x_i$ in time $t_i$

$L_k(X)$ means likelihood of subtree rooted at $k$, given it has state $X$
$P(X arrow Y, t)$ is probability that state $X$ at a node changes to $Y$ over time $t$
$pi_x$ is stationary probability of nucleotide $X$ at the root.

*Pseudocode*:
*Initialization*: At each leaf node, define $L_i(X) = 1$ if $X = x_i$, 0 otherwise.
*Recursion*: For each internal node with children $i, j$ $L_k(X) = sum_(Y, Z)P(X arrow Y, t_i)L_i(Y) dot P(X arrow Z, t_j)L_j(Z)$
*Final Step*: $L(T) = sum_X pi_X L_("root")(X)$

=== Bayesian Inference
Like maximum likelihood, based on probabilities, but tree topology is not single tree, but probability distribution of all trees. Uses Bayes' theorem to calculate posterior probability of trees based on prior probability of trees and observed data. Samples from probability distribution and updates model states iteratively

=== Tree Space Search
\ Stepwise Addition: Start from minimum tree (3 taxa) and add taxa, then optimize topology. 
\ Use starting tree: A tree with all taxa but is less accurate. Either use a cheap method for construction or randomly create.

== Summary
#table(
  table.header(
    [*Methods*], [*Optimality Criterion*]
  ),
  columns: 2,
  [Distance Methods], [Distance],
  [Maximum Parimsony], [Parimsony],
  [Maximum Likelihood], [Likelihood],
)

Note top-to-bottom is increasing accuracy and decreasing efficiency.

=== Newick Tree Format:
Newick Tree format is a text file like this:
#image("../assets/newick-format.png")