= Geometries
Geometric Spaces:
- Vector
- Affine
- Euclidean
- Cartesian
- Projective

== Vector Spaces
Definition:
- Set of vectors $cal(V)$
- Two operations. For $arrow(u) + arrow(v) in cal(V):$
  - Addition: $arrow(u) + arrow(v) + cal(V)$
  - Scalar multiplication: $alpha arrow(u) in cal(V)$ where $alpha$ is member of some field $bb(F)$

Axioms:
- Commutatativity: $arrow(u) + arrow(v) = arrow(v) + arrow(u)$
- Associativity: $(arrow(u) + arrow(v)) + arrow(w) = arrow(u) + (arrow(v) + arrow(w)) $
- Distributivity: $alpha(arrow(u) + arrow(v)) = alpha arrow(u) + alpha arrow(v))$
- Unique zero: $arrow(0) + arrow(u) = arrow(u)$
- Identity: $1 arrow(u) = arrow(u)$

Span: $cal(B) = {arrow(v_1), dots, arrow(v_n)}$
- $cal(B)$ spans $bb(V)$ iff any $arrow(v) in cal(V)$ is linear combination of $cal(B)$
Basis: minimum spanning set. All bases are equal size (dimension)

== Affine Spaces
Definition: 
- Set of vectors $cal(V)$ and set of points $cal(P)$
- Vectors $cal(V)$ are vector space, and points can be combined with vectors to make new points. $P + arrow(v) arrow.double Q; P, Q in cal(P); arrow(v) in cal(V)$

\ Frame: Affine extension of basis. Just the vector basis plus a point $cal(O)$ (the origin)
Dimension: Same as that of $cal(V)$

== Inner Product Spaces
For any vector space $cal(V)$, an inner product is a binary operator $arrow(u) dot arrow(v) in bb(R)$ with:
- Commutativity
- Distributivity
- Associativity
- $arrow(u) dot arrow(u) gt.eq 0$

== Euclidean Spaces
/ Metric Space: Any space with a distance metric defined on its elements
/ Distance Metric: Satsifies following axioms:
- $d(P, Q) gt.eq 0$ (Non-negativity)
- $d(P, Q) = 0$ iff $P = Q$ (Identity)
- $d(P, Q) = d(Q, P)$ (Symmetry)
- $d(P, Q) lt.eq d(P, R) + d(R, Q)$ (Triangle inequality)

Distance is intrinsic to the space, and NOT a property of the frame.

/ Euclidean Space: Metric is based on an inner (dot) product:
$d^2(P, Q) = (P - Q) dot (P - Q)$

/ Norm: $norm(arrow(u)) = sqrt(arrow(u) dot arrow(u))$
/ Angles: $cos(angle arrow(u) arrow(v)) = frac(arrow(u) dot arrow(v), norm(arrow(u))norm(arrow(v)))$
/ Perpendicularity: $arrow(u) dot arrow(v) = 0 arrow.double arrow(u) perp arrow(v)$

Perpendiculary is NOT an affine concept, no notion of angles in affine space. 

== Cartesian Space
Euclidean space with a standard orthonormal frame $(arrow(i), arrow(j), arrow(k), cal(O))$
Standard Frame is $F_s = (arrow(i), arrow(j), arrow(k), cal(O))$

To differentiate points and vectors, we use an extra coordinate: 
- 0 for vectors: $arrow(v) = (v_x, v_y, v_z, 0) arrow.double arrow(v) = v_x arrow(i) + v_y arrow(j) + v_z arrow(k)$
- 1 for points: $arrow(p) = (p_x, p_y, p_z, 0) arrow.double arrow(p) = p_x arrow(i) + p_y arrow(j) + p_z arrow(k) + cal(O)$

Coordinates have no meaning without an associated frame. 

== Inadequacies of vector spaces
We want to represent objects with a small number of primitives (eg. triangles, lines). Then we would want to do operations on the primitives (translate, rotate, etc.)

Vectors don't translate, so we'd need to define translation. 
e.g. $T(arrow(u)) = arrow(u) + arrow(t)$, then 
$T(arrow(u) + arrow(v)) &= arrow(u) + arrow(v) + arrow(t) \
&eq.not T(arrow(u)) + T(arrow(v)) \
&= arrow(u) + arrow(v) + 2 arrow(t)$

In affine spaces, we can define translation on vectors as identity, and trnalsation on points as a normal translation and get the translation as we desired.

== Summary
Vector spaces:
- Require basis set of vectors
- Define addition and scalar multiplication
- Axioms:
  - Commutativity
  - Distributivity
  - Associativity
  - Identity
  - Zero

Affine:
- All of previous
- Require origin point, 
- Defines addition between points and vectors
- Allow vectors + points.
- Allow a natural understanding of translations

Euclidean Space:
- All of previous
- Define distance metric (based on inner product)
  - Distance metric must have non-negativity, identity, reflexivity, and triangle inequality
- Allows distance, angles, perpendicularity, norm

Cartesian Space:
- Specific subset of euclidean space defined on standard orthonormal frame
- Define orthonormal frame (orthonormal basis + origin)
- Uses extra coordinate to define vectors vs points (0 for vectors, 1 for points)

#image("../assets/geometric_spaces_comparison.png")