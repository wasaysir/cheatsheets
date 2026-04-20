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

*Matrix Representation of Linear Transformation*: Given a frame, defined as ${arrow(v_1), dots, arrow(v_k)}$ and origin, $cal(O_v)$, let the matrix's first $k$ columns be $T(arrow(v_i))$, and the $k+1$-st column is $T(cal(O_v))$

== Geometric Transformations
/ Translation: *Not Linear. Rigid body*. Map points by offsetting their coordinates. Matrix representation: $mat(1, 0, delta x; 0, 1, delta y; 0, 0, 1)$
/ Scale about origin: *Linear. Not rigid body* Representation: $mat(s_x, 0, 0; 0, s_y, 0; 0, 0, 1)$
/ Rotation: *Linear. Rigid Body*. Rotation counterclockwise about origin, by angle $theta$, and is LINEAR. Matrix representation: $mat(cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1)$
/ Shear: *Linear. Not rigid body*. Modifies y-value in relation to others. Matrix representation: $mat(1, beta, 0; alpha, 1, 0; 0, 0, 1)$
/ Reflection: *Linear. Rigid body*. Reflection through a line. Matrix reflection across x-axis is $mat(1, 0, 0; 0, -1, 0; 0, 0, 1)$. To reflect across arbitrary line, need to transform that arbitrary line onto cardinal axis.

/ Composition of Transformations: Process of chaining multiple fundamental transformations to perform complex transformations. *_Order is very important._*

/ Change of Basis: Transformation from one coordinate frame to another. $P_(F_1 arrow F_2) = [[arrow(b_1)]_C,  dots [arrow(b_k)]_C, [O_(F_1) - O_(F_2)]_C]$. To get $[arrow(v)]_W$, in the column, coordinate $i$ is $f_i = arrow(v) dot arrow(w_i)$. If not orthonormal, normalization required. Note original vector (direction + magnitude) is preserved under CoB.

== Ambiguity
A linear transformation can have many 3 interpretations:
+ Change of coordinates
+ A transformation under same space
+ A map between two spaces

Under change of coordinates, nothing changes about points/vectors, in transformations, some do, in map everything changes. 

To specify a transformation we need:
- Matrix
- Domain & Range spaces
- Coordinate frames for each space

== Deriving rotation matrix
#image("assets/rotation-2d.png")

$x = r times cos(alpha)$
$y = r times sin(alpha)$

$x' = r times cos(alpha + beta)$
$y' = r times sin(alpha + beta)$

$x' &= r times (cos(alpha) cos(beta) - sin(alpha) sin(beta)) \
&= r times cos(alpha) cos(beta) - r times sin(alpha) sin(beta) \
&= x cos(beta) - y sin(beta)$

$y' &= r times(sin(alpha)cos(beta) + cos(alpha)sin(beta)) \
&= y cos(beta) + x sin(beta)$

To rotate around an arbitrary 3D axis, use identity on axis you're not rotating on, row and column. *Note that in RHS, we have cyclic cross product, $X times Y = Z, Y times Z = X, Z times X = Y$ So rotation about Z moves X-axis onto Y-axis, rotation about X moves Y-axis onto Z-axis and rotation about Y moves Z-axis to Y-axis.*

== Viewing frames
/ World Frame: Standard frame. Normally RHS. 

/ Handedness: Let your thumb point in x-axis, finger-directions toward y-axis, the direction of palm is z-axis.

/ LHS: Left Handed System. x to right, y up, z straight ahead. 
/ RHS: Right-handed system. y up, z in view direction, x to left. 

== Normals
Transforming normals can't be done with the same affine transforms on points because normal vectors aren't defined as differences of points. Tangent vectors are defined by differences of points. Normals are perpendicular to all tangents at a point. 

Let $M$ be a matrix transform. Let $t$ be a tangent and $n$ a normal vector at tangent. Then $arrow(N) dot arrow(T) = n^T t = 0$.

$t' = M t$, we want $n^T t = (n')^T t'$. Let $n' = A n$, $(n')^T t' = (A n)^T M t = n^T A^T M t$. Then let $A^T = M^(-1)$ to get the desired value, which makes $A = M^(-T)$. Thus this is the matrix to transform normals by to deal with affine transforms on points.
