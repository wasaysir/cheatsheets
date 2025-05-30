= Transformations

Population coding can pass data between neuron populations by transforming hidden activations. \
Naive: Decode to data space and then re-encode. \
Better: Bypass data space by multiplying decoder and encoder weights directly, resulting in  rank-1 matrix. $W = D_(x y) E_B in RR^(N times M)$ $D_(x y) in RR^(N times 1)$ and $E_B in RR^(1 times M)$. \
Using separate decoder-encoder matrices is computationally efficient. Total Time $O(N+M)$ for calculating $A D$ and $(A D)E$ unlike tied weights taking $O(N M)$