= Hidden Surface Removal
Parameters of HSR:
/ Online: Doesn't require all the polygons to complete
/ Device independent: Don't rely on device-details like Z-buffer
/ Geometry-load-independent: Don't need to have all polygons to run the algorithm.
/ Object-precise: Check precision in relation to objects compared to pixels which is *Image precise*
/ View-independent: HSR algorithm that doesn't require recomputing with a new view.
== Backface Culling
- Online
- View dependent
- Device independent
- Given vector $V$ from eye to polygon, find dot product $V dot N$ if value greater than 0, cull polygon, the normal is facing away from eye, we want normal facing same direction as eye.

- This requires extra work for non-convex objects (ex. donut where back of donut faces eye but is occluded by front part of donut)
- This doesn't work for two-sided non-volume-enclosing polygons (like a plane) where we want to keep the polygon no matter what.
- Cheap test that offers quick speed advantage (~2x) and can complement other HSR

== Painter's Algorithm
- Offline, device-independent, view-dependent
- Sort polygons by farthest $z$. Resolve ambiguities on overlaps (by subdividing polygon) and scan convert from largest $z$ to smallest $z$
- Requires all polygons at once in order to sort.
- $Omega(n^2)$ because you might have overlaps between all $n$ polygons, requiring ambiguities to be solved for all.

== Warnock's Algorithm
- Offline, device-dependent, view-dependent
- Subdivide image into 4 mini-windows, and keep subdividing until there is only one polygon in each window or the viewport is only 1 pixel in size, then shade pixel by closest polygon in pixel.
- $O(p n)$, $p$ number of pixels, $n$ number of polygons.
- This works as HSR because we can either guarantee no objects overlap in some portion of screen, or there is overlap and then we have to do the painter's algorithm on that pixel. IMO this is an adaptive optimization on painter's algorithm.

== Z-Buffer
- Maintain a depth-buffer with same dimension as frame-buffer to store z-values.
- Initialize z-buffer to infinity or depth of far clipping planes.
- When scan-converting 3D polygons, step in $z$ direction as well and in the write pixel command, check if the z-value of polygon is smaller than z-buffer value, if so, write the pixel to frame and z-buffer.
- $O(p_c + n)$: $p_c$: \# of scan-converted pixels, $n$ \# of pixels
- Simple, hardware-friendly
- Online/Geometry-load independent
- View-dependent
- Image-precision
- Doubles memory requirements
- Device dependent

== Binary Space Partitioning Trees
- Object-precise
- View-independent
- Geometry-load dependent
- Given a start polygon, break the rest of the scene into those in front "inside" and those behind "outside". Recursively break down this process for all objects in the scene.
  - If a polygon has sections both inside and outside, then subdivide that polygon and proceed.
- If view is facing front of root node, then you traverse front halfspace recursively, otherwise back halfspace recursively. Always display polygons back-to-front, possibly obscuring distant polygons first.
