= Clipping

/ Clipping: Remove points outside region of interest.

/ Point Clipping: Remove points outside a window
/ Line Clipping: Remove portion of line segment outside window

/ Parametric representation of line: $L(t) = A + t(B - A)$
- For $t in RR, L(t)$ represents infinite  line
- For $t in [0, 1]$, $L(t)$ represents line segment from A to B
- Useful for generating points on a line, not for testing if point is on a line.

/ Implicit representation of line: $l(Q) = (Q - P) dot arrow(n)$
- $P$ is point on line, $arrow(n)$ is perpendicular line.
- $l(Q)$ gives signed distance of point $Q$ to line.
- Convention: direction of normal is "inside"
- If $l(Q)$ is zero, $Q$ is on the line.

== Clipping point to halfspace
Procedure: 
- Represent window edge as implicit line
- Check sign of $l(Q)$, if $l(Q) > 0$, it's inside. If $l(Q) < 0$ it's outside and discard it. If on the boundary, case-dependent.

== Clipping line segment to halfspace
/ Liang-Barsky Algorithm: Algorithm to clip line segments to any convex window. Clipping should be done as early as possible when simple, for ex. after perspective division. 

+ If both points of line segment are inside, keep the entire segment.
+ If both points of line segment are outside, discard entire segment.
+ If one is inside, and other is outside, generate new segment between point inside and point that touches the boundary.

Representations: window edge is implicit; line segment is parametric. 

To retrieve intersection point, we want $t$ such that $l(L(t)) = 0$, note $l(Q)$ is implicit window-edge and $L(t)$ is parametric segment. 

$(L(t) - P) dot arrow(n) &= (A + t(B - A) - P) dot arrow(n) \
&= (A - P) dot arrow(n) + t (B - A) dot arrow(n) \
&= 0$

Solving for $t$ gives us $((P - A) dot arrow(n)) / ((B - A) dot arrow(n))$

*Generalization to 3D*: Each halfspace now represents a plane, other than that everything else is the same.

== Liang-Barsky Outcodes
Method to quickly evaluate a clipping of line segments

Procedure:
- Do trivial tests against all edges
  - Each point $P_i$ has outcode $O_i$
  - Outcodes are bitvectors
    - $O_i[j] = 1$ if $cal(l_j)(P_i) gt 0$ (Point is "inside" for specific line)
    - $O_i[j] = 0$ if $cal(l_j)(P_i) lt.eq 0$ (Point is on or "outside" for line)
- Combine results to trivially accept/reject
  - Trivially accept on window if all edges trivially accept $A B$
    - $O_A & O_B = "all" 1's$ (bitwise and)
      - This means both points, $A$, and $B$ are "inside" for each edge, so each point is inside the point
    - $O_A | O_B eq.not "all" 1's$ (bitwise or)
      - If one bit is $0$, this means both points are outside for a specific line, so it cannot be inside the window



