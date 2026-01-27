= Limits

*Single Limit Definition*:
If for every $epsilon > 0 exists delta > 0$ then $lim_(x arrow.r a) f(x) = L$ means
$abs(f(x) - L) < epsilon$ whenever $0 < abs(x - a) < delta$

and $lim_(x arrow.r a) f(x) = L$ if and only if $lim_(x arrow.r a^-) f(x) = L$ and $lim_(x arrow.r a^+) f(x) = L$

*r-neighbourhood*: Given point $(a,b) in RR^2$, it is the set $N_r(a, b) = {(x, y) in RR^2; bar.v.double (x, y) - (a, b)bar.v.double < r}$

*Multivariable Limit Definition*: If for every $epsilon$, there exists $delta > 0$, that $0 < bar.v.double (x, y) - (a, b) bar.v.double < delta$ implies $abs(f(x, y) - L) < epsilon$ then $lim_((x,y) arrow.r (a, b)) f(x, y) = L$

== Limit Theorems
If $lim_((x,y) arrow.r (a, b)) f(x, y) = L$ and $lim_((x,y) arrow.r (a, b)) g(x,y) = M$ both exist then, $lim_((x,y) arrow.r (a, b)) [f(x, y) + g(x, y)] = L + M$

Also, $lim_((x,y) arrow.r (a, b)) [f(x, y)g(x, y)] = L M$

Also, $lim_((x,y) arrow.r (a, b)) frac(f(x, y), g(x, y)) = frac(L, M) "if" M eq.not 0$

If $lim_((x,y) arrow.r (a, b)) f(x, y)$ exists, then it is unique.

== Proving limits don't exist
In single-variable limits, we approached the point from left-side and right-side and showed that we had different values to show a limit doesn't exist. In multivariable functions, we approach from any two curves.

=== Coefficient solution
One approach to simpify finding no limit is to approach by introducing an arbitrary coefficient, and if the limit depends no the coefficient, then it is not unique, and therefore doesn't exist.

Ex: We try $y = m x$ for a limit passing through (0, 0). Note it's important to find a curve that passes through the point of the limit. 

== Proving limits exist

=== Squeeze Theorems
If there exists a function $B(x, y)$ such that $abs(f(x, y) - L) lt.eq B(x, y)$ for all $(x, y) eq.not (a, b)$ in the neighbourhood of $(a, b)$ and $lim_((x, y) arrow.r (a, b)) B(x, y) = 0$ then $lim_((x, y) arrow.r (a, b)) f(x, y) = L$

Process for finding limits:
1. Start by approaching limit with straight lines of different slope.
a. If limit depends on slope, limit doesn't exist.
b. If limit exists, and doesn't depend on slope, it may exist and equal derived limit.
2. Apply squeeze theorem to prove limit exists and equals $L$
3. If no suitable inequality exists, then either a suitable inequality exists that you couldn't find, or if you approach limit along curves, you may get a different limit than $L$, proving it doesn't exist.