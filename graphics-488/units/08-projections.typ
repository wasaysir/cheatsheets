= Projections

/ Perspective Projection: Identify points with a line through the eyepoint. This is NOT an affine transformation.
  - Angles are not preserved
  - Distances are not preserved
  - Ratios of distances are not preserved
  - Affine combinations are not preserved
  - Straight lines map to straight lines (because 3D straight line and cam center form a flat plane. This plane intersecting the image plane always results in a straight line)
  - Cross ratios are preserved

/ Cross Ratio: Ratios between of ratios of distances. Let $abs(A C) = a_1, abs(C D) = a_2, abs(A B) = b_1, abs(B D) = b_2$, then $(a_1/a_2)/(b_1/b_2) = (a'_1/a'_2)/(b'_1/b'_2)$

#image("../assets/cross-ratio.png")

In affine transformations, in dimension $n$ space, an image of $n+1$ points/vectors defines the affine map. In projective transformation, you require $n+2$. Mapping of vectors is ill-defined in projective transformation, since $arrow(v) = Q - R = R - S$ but $P(Q) - P(R) eq.not P(R) - P(S)$

/ Homogeneous Coordinates: Set of representations for the same point variable to a single parameter. Ex $(x, y, z) eq.triple (k x, k y, k z), k eq.not 0$ The map loses all $z$ information.

== Final Projection Matrix
$mat(
  (cot(theta / 2))/"aspect", 0, 0, 0;
  0, cot(theta / 2), 0, 0;
  0, 0, plus.minus (f+n)/(f-n), (-2 f n)/(f - n);
  0, 0, plus.minus 1, 0
)$

$plus.minus$ is positive if we look down the $z$ axis, and negative if we look down $-z$ axis.

== 3D Clipping
Clip to near plane before projection (to avoid division by zero if $z = 0$). Clip to 6 sides of frustum after projection, since it's simpler.

/ Homogenization: The process of converting a homogenous coordinate to a regular format, i.e. moving $vec(x, y, z, w) = vec(x / w, y / w, z / w, 1)$

== Homogenous Clipping
We have to be careful about clipping after homogenization because the division can annihilate signs, which creates ambiguity when trying to clip.

Ex. Point A: (x: 2, w: 4) $arrow.double$ $overline(x) = 0.5$. This fits the $[-1, 1]$ range.
Point B: (x: -2, w: -4) $arrow.double$ $overline(x) = 0.5$. This also fits the $[-1, 1]$ range, but it shouldn't, because $w$ represents depth, so it shouldn't be allowed to fit.

*Clipping Homogeneous Coordinates*: Assuming window of $[-1, 1] times [-1, 1]$, to clip projected coordinates to $X = 1$, you need to clip homogeneous coordinate $x / w = 1$, and thus you can clip against the plane $x + w = 0$ and the point is only visible if $x + w > 0$. Similar planes exist for opposite $X$ plane and for the $Y$ planes and near and far clipping planes.
