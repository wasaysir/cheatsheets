= Clipping

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

