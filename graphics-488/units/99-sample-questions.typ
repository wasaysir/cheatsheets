- Why do affine transformations map parallel lines to parallel lines?
- What is a linear combination of points, if the sum of coefficients sum to 2? or -1?
- What is the formal definition of a point? A vector?
- How do linear transformations differ from affine transformations?
- What is point subtraction?
- What is point blending?
- Johnny's rendering times are extremely slow. When tracing his ray, he got the following ray intersection coefficients. (3.43439043, -2.3436934839, 0.00003000000, 4.53943). Can you identify the problem?

- What is the difference between point and line clipping?
- What are the two representations of a line?
  - When do you use each?
- How do you test if a point is on a line?
- If $l(Q)$ is +3, is $Q$ inside or out? if $l(Q) = 0$?
- If $t in [0, 1]$, how does this affect the parametric representation of the line?
- If points $A$ and $B$ are coincident, how does this affect the parametric representation of the line?

- What is the simplest projection transformation?
  - What extension of this retains depth information? What's the downside to this implementation, how does it reverse depth information?
  - What extension ensures $z'$ maps to $[-1, 1]$?
  - What extension ensures $y$ maps to $[-1, 1]$? Why would we want it to map this way?
  - Why don't we also map $x$ to $[-1, 1]$

- Why do we need to retain the $z$ information after projection, instead of just mapping $z$?
- What's wrong with this mapping? $(x, y, z, 1) arrow ((x n)/ z, (y n) / z, z, 1)$? (ANSWER: It fails to map lines to lines. Look at page 64 of textbook)
- What's wrong with this mapping? $(x, y, z, 1) arrow ((x n) / z, (y n) / z, n, 1)$? (ANSWER: It maps lines to lines, but loses depth information)

- What value of $z$ maps to $0$ after a perspective projection? (ANSWER: $(2 f n) / (f + n))$
- Why do we clip the near plane before projection?
- When do we clip in 3D?

- Why do we need to calculate $arrow(v_y)$? Why not just use up vector?
- What happens if up vector is parallel to the viewing direction?
- What happens to points behind the camera after you do the projection transformation? (ANSWER: THEY CAN BE MAPPED IN FRONT OF IT. LOOK AT 9.3 Supplementation information)
