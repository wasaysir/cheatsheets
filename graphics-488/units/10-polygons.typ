= Polygons
/ Polygon: Planar set of ordered points with no holes or line crossing. Points are ordered in counter-clockwise order. We use a right-hand convention, where you curl your fingers in the order of the vertices and the direction of your thumb is the normal vector direction.

/ Degeneracy: Coincident points of a polygon, or a point that is collinear to a line segment on the polygon.

/ Convex: $forall p, q$ points inside polygon, the line segments joining the points is also inside.
/ Concave: Not convex

Note affine transformations may introduce degeneracies (Ex. Orthographic projection projects polygon onto line segment)

== Polygon Clipping (Sutherland-Hodgman)
- Window must be convex, but polygon being clipped can be anything.

Procedure:
+ Polygon to be clipped is $v_0, dots, v_n$
+ Each edge is pair $v_i, v_(i + 1)$, $i = 1, dots, n$ including wraparound edge $v_n, v_1$
+ For each window edge:
  + Output a new set of vertices that represent the polygon after being clipped to this edge.
    + During this edge intersection, you traverse each polygon edge and output an ordered set of points representing the window-edge-clipped polygon.

4 cases of polygon edge intersection:
+ Both points inside the window: Only output the second point.
+ Start point inside, but next point outside: Output the point where line segment intersects window edge.
+ Both points outside: Output nothing
+ Start point outside, next point inside: Output point where line segment intersects window edge + next point.

#image("../assets/window-edge-intersection.png")

== Line-Drawing (Digital Differential Analyzer)
This is the procedure for drawing a line. Cartesian slope-intercept equation for a line is $y = m x + b$. To draw a line, you sample various points $x_k, x_(k+1), dots$ and get according y-values $m * x_k + b, m * x_(k+1) + b, dots$

If $m lt.eq 1$ we sample at unit $x$ intervals and calculate each successive $y_(k+1) = y_k + m$.

This procedure is used to draw:
+ $d_x = x_1 - x_0; d_y = y_1 - y_0;$
+ steps = $max(d_x, d_y)$ (this ensures you have enough steps to avoid jumps)
+ $x_(i n c) = d_x / "steps"; y_(i n c) = d_y / "steps"$
+ $x = x_0; y = y_0;$
+ For each $i arrow.l 0 "to steps"$:
  + Plot pixel as $"round"(x), "round"(y)$
  + Update $x = x + x_(i n c)$
  + Update $y = y + y_(i n c)$

For lines with slopes greater than 1, we reverse roles of $x$ and $y$ as in sampling with unit $y$ intervals and calculating each next $x$ value as $x_(k + 1) = x_k + 1/m$ This is already accounted for in selecting the "max" steps.

== Polygon Scan Conversion
To rasterize a polygon, we'll want to scan convert a polygon to identify which points to hit. To scan-convert we need a triangle with one edge on the y-axis. This can be done by splitting the polygon into triangles, and then splitting the triangle by the vertex with the middle y-value.

Process:
Assume we have a triangle with points A and B on the horizontal and C as the third point. Define $L_1(t)$ as the line $A C$ and $L_2(t)$ as the line $B C$.
+ $d_0 = (C_x - A_x) / (C_y - A_y)$
+ $d_1 = (C_y - B_y) / (C_y - B_y)$
+ $x_0 = A_x; x_1 = B_x; y = A_y$
+ while $y lt.eq C_y$
  + for $x in [x_0, x_1]$: WritePixel(x, y)
  + Step to new line: $x_0 += d_0; x_1 += d_1; y += 1$

== Requirements
- Objects should be completely solid and watertight (no gaps between vertices and no holes in vertex (bad)
- No T-vertices (Vertex lies on edge of another polygon instead of sharing a mutual vertex)
- No overlapping co-planar faces (Hard to deal with overlaps due to FP issues)
- Well-shaped polygons are better. Long, skinny polygons have numerical issues.
