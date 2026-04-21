= Rotating around arbitrary axis
Can derive matrix for angle-axis rotation by composing basic transformations. Rotation is given by $arrow(a) = (x, y, z) "and" theta$ assume $arrow(a) = 1$. We will map $arrow(a)$ onto a canonical axis, rotate by $theta$ and map back. Check affine transformations or 14.2 for details.

*3D Rotation Interfaces*:
- Virtual Sphere, where you map a start point and get the tangent vector for that point.
  - Define portion of screen as projection of virtual sphere
  - Get two sequential mouse positions, $S$ and $T$
  - Map 2D point $S$ to 3D unit vector $arrow(p)$ on sphere (using sphere equation $x^2 + y^2 + z^2 = 1$)
  - Map 2D vector $arrow(S T)$ to 3D tangential velocity $arrow(d)$ and normalize.
  - Axis $arrow(a) = arrow(p) times arrow(d)$
  - Angle: $theta = alpha abs(arrow(S T))$. Choose $alpha$ so $180 degree$ rotation allowed.
  - Save $T$ to use as $S$ for next time.
- Arcball, where you map two points on the sphere and map a rotation between those two points.
  - Map 2D point $S$ to 3D vec $arrow(p)$ and do the same for $T$
  - Take the cross product between these two vectors to get the axis of rotation, and use the magnitude to determine the angle theta.
