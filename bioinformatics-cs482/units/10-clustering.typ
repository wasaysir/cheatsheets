= Clustering

\ Good Clustering Principle: Every pair of points from same cluster should be closer to each other than any pair of points from different clusters.

Formal definition:
Optimization given set of data points $X$, distance metrix $d(x_i, x_j)$ and number of clusters $k$ the goal is to partition $X$ into subsets $C = {C_1, dots, C_k}$ such taht objective function $cal(L)(C)$ is optimized, so $C^* = arg min_C cal(L)(C)$

== K-Means
Given dataset, K-means clustering aims to partition observations such that within-cluster sum-of-squares is minimized: $cal(L)  =sum_(i=1)^K sum_(j=1)^(n_i) norm(x^((i))_j - mu_i)^2$

*Algorithm*:
- Initialize centroids
- While not converged
- Update cluster assignments to closest cluster
- Update centroid

#image("../assets/kmeans-algo.png")

*Robustness not guaranteed in KMeans, because of sensitivity to outliers*

*Elbow Method*:
- Heuristic for selecting $K$
- Plot objective function against different values of $K$
- Optimal $K$ is at point where adding another cluster results in minimal improvement.

#image("../assets/elbow-method.png")

*Elbow Formulation*:
- Compute clustering for $1, 2, dots, K_"max"$
- Plot clustering Loss vs number of clusters
- Optimal $K$ at most noticeable "bend"

== Hierarchical Clustering
- Determining clusters within clusters (ex phylogenetic class)

*Dendograms*: 
- Horizontal cuts at different heights are different clusterings
- Higher cut (larger distance): Fewer, larger clusters
- Lower cut: More clusters, finer granularity
- Higher cut: Fewer, broader clusters

#image("../assets/dendogram1.png")
#image("../assets/dendogram2.png")

Linkage methods:
- Single Linkage: Merge clusters by minimum distance between clusters. $d(C_i, C_j) = min_(x in C_i, y in C_j) d(x, y)$
- Complete Linkage: Merge clusters by maximum distance between clusters. $d(C_i, C_j) = max_(x in C_i, y in C_j) d(x, y)$
- Average Linkage: Merge clusters by average distance (UPGMA) $d(C_i, C_j) = 1/(abs(C_i) abs(C_j)) sum_(x in C_i) sum_(y in C_j) d(x, y)$

== Density Based Clustering
DBSCAN clusters points together based on density. 

== Neural Clustering
Using a deep neural network, we can learn lower-dimensional representations (then cluster the points based on those lower-dimensional representations) For instance, via autoencoder network.

=== Neural Information-Based Clustering
To train discriminative model without labels, we can do this through explicit maximization of mutual information between input and discrete output probability distribution.

\ Mutual Information: Measure of mutual information provided between two variables. How much you know about $X$ given $Y$ and vice versa.

#image("../assets/mut-info.png")

$
  M I(y, x) &= integral integral p(y, x) log (p(x, y))/(p(x) p(y)) d y d x \\
  &= integral integral p(y | x) p(x) log (p(y | x))/(p(y)) d y d x \\
  &= integral integral p(y | x) p(x) log p(y | x) d y d x - integral integral p(y | x) p(x) log p(y) d y d x \\
  &= EE_(x tilde p(x)) [sum^K_(j=1) p(y_j | x) log p(y_j | x)] - EE_(x tilde p(x)) [sum^K_(j=1) p(y_j | x) log p(y_j)] \\
  &= 1/N sum^N_(i=1) sum^K_(j=1) p(y_j | x_i) log p(y_j | x_i) - sum^K_(j=1) log p(y_i) EE_(x tilde p(x))[p(y_j)|x)] \\
  &= 1/N sum^N_(i=1) sum^K_(j=1) p(y_j | x_i) log p(y_j | x_i) - sum^K_(j=1) log (1/N sum^N_(i=1) p(y_i | x_i)) dot 1/N sum^N_(i=1) p(y_j | x_i) \\
  &= - overline(H(sigma)) + H(overline(sigma))
$

Note that $p(y_j | x_i) = sigma_(i j) = phi(x_i) = "softmax"(f_theta(x_i))$ So you can use the softmax outputs for this calculation.