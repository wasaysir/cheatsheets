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

== UPGMA
*UPGMA*: Unweighted Pair Group Method with Arithmetic Mean

*Linkage Criterion*: Distance metric between two groups (not just sequences, but 2 separate groups of sequences)

Given distance matrix, find closest pair of species, then combine them to a "new node" and recalculate the values for it and the remaining sequences by $"UPGMA" = "Sum of pairwise distances" / "Number of pairs"$ and continue until you're done.

This best describes topology and distance of species.

== Neighbour Joining
*Additive Matrix*: There exists an additive tree fitting the matrix
*Additive Tree*: Given symmetric $n times n$ 0-diagonal matrix, for any neighbouring leaves $i, j$, with parent $m$, the distance from $m$ to any other leaf $k$ is $d_(k, m) = (d_(i, k) + d_(j, k) - d_(j, l)) / 2$
*Four-Point Theorem*: Distance matrix is additive iff two of the sums are equal and third is less than or equal to other sums: 
#image("../assets/fourpoint.png")


=== Procedure
Create auxiliary matrix where $Q(i, j) = (n-2)d_(i, j) - sum_(k in L) d_(i, k) - sum_(k in L) d_(j, k)$. Then find elements with a minimum non-diagonal value. Then, let $Delta = ("Total Distance"(i) - "Total Distance"(j))/(n - 2)$, then $"limbLength"_i = 1/2 (D_(i, j) + Delta)$ and $"limbLength"_j = 1/2 (D_(i, j) - Delta)$
Then, add a new row/column to D, so that $D_(k, m) = D_(m, k) = 1/2 (D_(k, i) + D_(k, j) - D_(i, j))$ and remove rows $i$ and $j$ from D. Then repeat recursively and add to the graph as needed.

Given set of leaf nodes, for every pair, define new q-metric relative to other species, as $D_(i j) - (r_i + r_j), r_i = 1/(abs(L) - 2) sum_(k in L) d_(i k)$

Then, find the smallest q-metric and combine the two species to make a new internal node as average of the two.