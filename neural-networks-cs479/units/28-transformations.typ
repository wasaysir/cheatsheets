= Transformations

We use population coding to pass data between populations of neurons. To do this, we need some way to pass hidden activations between the other.

Naive: Decode activations to data space, then re-encode for second population. Alternative is to bypass data space by multiplying decoder weights by encoder weights directly. $W = D_(x y) E_B in RR^(N times M)$. This i rank-1 matrix since $D_(x y) in RR^(N times 1)$ and $E_B in RR^(1 times M)$. 

It's better to use separate decoder-encoder because it's computationally efficient, since it's low-rank. Calculating $A D$ takes $O(N)$ time. $(A D) E$ takes $O(M)$ time, so total time is $O(N + M)$, whereas tied weights would take $O(N M)$