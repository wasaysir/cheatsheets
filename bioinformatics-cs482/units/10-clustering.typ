= Clustering

\ Good Clustering Principle: Every pair of points from same cluster should be closer to each other than any pair of points from different clusters.

== K-Means
Given dataset, K-means clustering aims to partition observations such that within-cluster sum-of-squares is minimized: $cal(L)  =sum_(i=1)^K sum_(j=1)^(n_i) norm(x^((i))_j - mu_i)^2$

*Algorithm*:
- Initialize centroids
- While not converged
- Update cluster assignments to closest cluster
- Update centroid

*Robustness not guaranteed in KMeans, because of sensitivity to outliers*

*Elbow Method*:
- Heuristic for selecting $K$
- Plot objective function against different values of $K$
- Optimal $K$ is at point where adding another cluster results in minimal improvement.

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
- Single Linkage: Merge clusters by minimum distance between clusters.
- Complete Linkage: Merge clusters by maximum distance between clusters:
- Average Linkage: Merge clusters by average distance (UPGMA)

== Density Based Clustering
DBSCAN clusters points together based on density. 

== Neural Clustering
Using a deep neural network, we can learn lower-dimensional representations (then cluster the points based on those lower-dimensional representations) For instance, via autoencoder network.