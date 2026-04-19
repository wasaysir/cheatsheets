=

/ Linear Combinations: $sum_i alpha_i arrow(u_i)$
/ Linear Combinations: $T(sum_i alpha_i arrow(u_i)) = sum_i alpha_i T(arrow(u_i))$

/ Point Subtraction: $Q - P$ means $arrow(v) in cal(V)$ s.t. $Q = P + arrow(cal(v))$ for $P, Q in PP$
/ Point Blending: $Q = a_1 Q_1 + a_2 Q_2$ where $a_1 + a_2 = 1$

/ Vector Definition: $sum alpha_i P_i$ is a vector *iff* $sum alpha_i = 0$
/ Point Definition: $sum alpha_i P_i$ is a point *iff* $sum alpha_i = 1$

*Point Distance Property*: Let $Q$ be a point s.t. $Q = a_1 Q_1 + a_2 Q_2$, then $abs(Q - Q_1)/abs(Q - Q_2) = a_2 / a_1$ ($a_1 + a_2 = 1$)

/ Parametric Line Equation: $L(t) = A + t(B - A)$, $t in RR$
/ Parametric Ray Equation: Parametric Line Equation, but $t gt.eq 0$

== Affine Transformations
/ Affine Transformation: Domain and Range: Affine spaces. Maps vecs to vecs and points to points. Is a linear transform on vectors, and follows $T(P + arrow(u) = T(P) + T(arrow(u)))$. Generally, $T(sum_i^n a_i Q_i) = sum_i^n a_i T(Q_i)$

Affine transformations are a bigger class than linear transformations because they can translate points.

Affine transformations map parallel lines to parallel lines because all $T(P + arrow(v)) = T(P + Q - R) = T(P) + T(Q) - T(R) = T(P) + T(arrow(v))$

/ Coordinates: A scale-less set of coefficients for a point relative to a frame. 
