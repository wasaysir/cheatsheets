= Universal Approximation Theorem

For all continuous functions in the domain of $n$ parameters in $[0,1]$ domain each, can be approximated as finite sums of sigmoid functions.

*Sigmoid Function*: Goes to 1 for positive infinity and 0 for negative infinity.

== Process
1. By giving infinite weight to $sigma(w x)$, this approximates a threshold function.
2. We create piece function as difference of threshold functions: $P(x; b, delta) = H(x; b) - H(x; b + delta)$
3. Approximate each section of the function, as $G(x) = sum_(j=1)^(N') f(a_j) P(x; b_j, delta_j)$ each is within $epsilon$ band