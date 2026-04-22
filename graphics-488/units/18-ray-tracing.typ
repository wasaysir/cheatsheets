= Ray tracing
/ Ray casting: Shoot rays from a specific point (e.g. "Lookfrom") towards points of interest and compute ray-object intersections, the closets intersection points are considered visible. Pixels associated with their projection on screen are shaded accordingly. 

/ Ray tracing: Not just first interaction with object, but simulates light with multiple interactions with objects. Like reflections or transmissions. 

/ Whitted Ray tracing: Instead of tracing rays from light to camera, trace light from camera to light. This is only possible if materials that propagate light can be characterized by BSDF following *Helmholtz reciprocity relationship*. 

Ray tracing and casting both work in world space, where a ray is defined by its origin and direction in WCS. Origin of primary ray is associated with lookfrom. The ray direction can be found by taking $p_k$ (pixel coordinate in screen coordinates), converting it to world coordinates ($p_"world"$) and then making the ray origin "Lookfrom" and the direction is $p_"world" - "Lookfrom"$

In order to determine these values, we need Lookfrom, Lookat, $arrow(U p)$, field of view ($theta$) and aspect ratio, as well as distance $d$ in world coordinates.

#image("../assets/camera-ray.png")

To convert $p_k$ to $p_"world"$, do this:
+ Make $z_k = 0$ and translate by $(-n_x/2, -n_y/2, d)$ using translation matrix $T$
+ Preserve aspect ratio and change x-axis directoin to scale by $(-h/n_y, w/n_x, 1)$ using scaling matrix $S_2$. Note $h = 2 d tan (theta/2)$

#image("../assets/pixel-to-world-ray.png")

+ Rotate by $R_3 = mat(u_x, v_x, w_x, 0; u_y, v_y, w_y, 0; u_z, v_z, w_z, 0; 0, 0, 0, 1)$ where $arrow(w) = "unit"("Lookat" - "Lookfrom")$, $arrow(u) = "unit"(arrow(U p) times arrow(w))$, $arrow(v) = arrow(w) times arrow(u)$
+ Translate by Lookfrom

We don't need perspective matrix because these rays provide that for us.

== Ray intersections
=== Triangle intersection

Triangle has 3D vertices $P_0, P_1, P_2$ and any point in *plane* of triangle is defined as $P(x, y, z) = alpha P_0 + beta P_1 + gamma P_2$ where $alpha + beta + gamma = 1$. 

If $beta gt.eq 0$ and $gamma gt.eq 0$ and $beta + gamma lt.eq 1$ then the point is on the triangle itself, not just the plane. Therefore parametric equation of triangle is: $P(x, y, z) = P_0 + beta (P_1 - P_0) + gamma (P_2 - P_0) $ 

Rays are expressed as $P(x, y, z) = a + t (b - a)$, so a ray intersects the triangle iff the two equations are equivalent. $P_0 + beta (P_1 - P_0) + gamma (P_2 - P_0) = a + t (b - a)$ and solve for unknowns $beta, gamma, t$ and determine if $beta, gamma$ are valid to determine if $t$ is valid. 

This is a system of equations, because you do an equation for each component of x, y, z. Then you can solve the matrix system using Gaussian elimination. 

=== Sphere intersection
Sphere can be implicitly defined as $(P - c) dot (P - c) = r^2$. This can be written as $(P_x - c_x)^2 + (P_y - c_y)^2 + (P_z - c_z)^2 = r^2$

To compute intersection of ray with sphere, replace $P$ from implicit equation of sphere with parametric equation of ray, which gives you $((a + t(b-a)) - c) dot ((a + t(b-a)) - c) = r^2$. 

Expands to:
$(t(b-a) + (a - c)) dot (t(b-a) + (a - c)) = r^2$
$t^2(b-a) dot (b-a) + 2t(b-a) dot (a-c) + (a-c) dot (a-c) - r^2 = 0$

Then, we can consider this a quadratic on $t$, so solve it via quadratic equation. If it has zero roots, it misses the sphere, if it's 1 root, it is tangent to sphere at single point, and with 2 roots, it hits the sphere at two points. Then you should pick the one closest to the point of origin and ensure that that $0 lt.eq t$ and if we're checking it compared to a specific destinatoin point, check if $t lt.eq 1$

== Ray Tracing Kernel
Basic procedure:
```
rayColour(ray r, point2D uv, integer maxHits):
  // Diffuse, specular, emissive
  colour kd, ks, ke // RGB triples
  vector n // Normal
  point3D p // point
  enum material_type

  if (hit(r, t, n, uv, kd, ks, ke, material_type)):
    col = ke * Le + kd * La // Le = emitted radiance, La = ambient radiance
  
    p = r.point_at_parameter(t)

    if(material_type == diffuse):
      col = col + kd * directLight(p, uv)
    
    if(material_type == specular AND maxHits > 0):
      maxHits = maxHits - 1
      reflected_ray = Reflection(r.direction, n)
      col = col + ks * rayColour(reflected_ray, uv, maxHits)
    
    return col
  else:
    return Background colour
```

MaxHits is a simplified model for attenuation. 
DirectLight computes contribution of the light source. It tests intersection of a shdow ray with any object in the scene. The shadow ray has origin on the diffuse object and its destination is on the light source. If no objects occur, then the light source's radiance is added, otherwise it's not. If there are multiple light sources, each light source is added. 

*For simple objects/primitives* like triangles and polygons, the normal is a simple application of cross products. Basically, take adjacent two vertices and define a vector for those two, and then take the cross product to get the normal. For implicitly defined surfaces, the normals are calculated using the gradients of those functions. 

Ex. Circle gradient is calculated as $delta g(x, y, z) = ((delta g(x, y, z))/(delta x)), (delta g(x, y, z))/(delta y)), (delta g(x, y, z))/(delta z))$

Thus normal of sphere is represented as $arrow(n) = nabla f(x, y, z) = (2 (x - c_x), 2 (y - c_y), 2(z - c_z))$ where $x, y, z$ is point on sphere. 

=== Surface information:
- Illumination models require:
  - surface normal vectors at intersection points
  - ray-surface intersection computation must also yield a normal
  - light-source directions must be established at intersection
  - shadow information determined by light-ray intersections with other objects
- Normals to polygons:
  - provided by planar normal
  - provided by cross product of adjacent edges
  - Or use Phong normal interpolation if normals specified at vertices

*REMEMBER*: Affine transformations such as $M$ need to be transformed by $M^(-T)$ onto the normals to ensure they're done properly. So do this to all model transformations.

=== Constructive Solid Geometry
In CSG all primitives are solids, and we add a new internal node, a boolean operation which can do intersection, union, or difference. Leaf nodes represent primitives, internal nodes represent transformations, materials or boolean operations. 

In CSG, when traversing the transformation tree, after each transformation is applied, primitives are warped. Rather than intersect the ray with a warped primitive, we transform the ray, applying the inverse transformation onto the ray, then after we've got our points and normals, we will apply the actual transformation to the point and the normal. 

#image("../assets/csg-traversal.png")

To do CSG, we perform ray intersection with each primitive, this will give a set of line segments (the start of where the ray intersects the object and the end of where the ray intersects the object ex. two ends of a sphere) and we perform boolean operations on these line segments to determine the final operation.)

Also be careful with normals, they flip when we take the difference in CSG. 

Examples of CSG commands are Union, Intersection, Difference.

=== Texture Mapping
When we intersect a ray with an object, we'll get a set of 2D coordinates on the object itself, for instance $beta, gamma$ in the triangle intersection. We use these coordinates for the $u, v$ mapping, where we query the $u, v$ coordinates in our texture map and use that as the surface colour on that point on the polygon and then use our illumination model to determine the colour on that pixel. 

We often use bilinear interpolation between the vertices of the polygon to get a better approximation of a texture. 

=== Bump Mapping
Bump mapping allows perturbing of the normal based on the $u, v$ coordinates of the polygon. This is used for lighting calculation and helps with avoiding the use of large geometries. 

For a given surface defined parametrically, $Q(u, v)$ a normal at point $Q(u, v)$ can be obtained through cross product of tangent vectors on the surface at point $Q(u, v)$ which correspond to partial derivatives of $Q(u, v)$ wrt to parametric variables $u$ and $v$ and are denoted by $Q_u, Q_v$ respectively. The goal is to get perturbed normal $N' = N + D$. SO to get $N'$ we need to compute displacement $D$ which first requires axes $X, Y$. 

$X = N times Q_v; Y = N times Q_u$ Then displacement $D$ is given by $D = B_u Y - B_v X$ where $B_u$ and $B_v$ are partial derivatives of the bump map at the point $B(u, v)$. Using user-defined thresholds $epsilon$ we get approximate these as:
$B_u = (B(u + epsilon, v) - B(u - epsilon, v)/(2 epsilon)$ and a simlar process for $B_v$

This doesn't affect its geometry so it can't completely simulate shadowing, where a hill creates a shadow along a valley on the texture. This isn't mapped in the incident light because it can't do ray intersection with the "assuemd displacement of the texture".

=== Solid Textures
2D textures can betrya 2D nature in images, and its hard to texture map onto curved surfaces, so you can use a 3D texture (which is usually procedural). 
Ex. ```
if ( (floor(x)+floor(y)+floor(z))%2 == 0 ) then
return RED;
else
return SILVER:
end
```

this gives a 3D checkerboard.

This approach requires procedurally defining a texture field in object space. Given a point $p(x, y, z)$ on the object surface, the colour is defined as $T(x, y, z)$ where $T$ is the value of the texture field. The main advantage of this approach is that textures are limited to analytical functions, and can simulate natural-looking effects like terbulence or veins in marble rock. 

/ Mesh displacement: A map onto a surface which actually modifies the mesh, where the map is basically a displacement map onto the mesh. This is more powerful than the other texture mapping methods because it actually changes the texture.

=== Bounding Boxes
Ray tracing is slow, you can either reduce cost of ray intersection or intersect with fewer objects. Bounding boxes place a box around an object and only compute ray intersection with an object if it intersects the bounding box. If box is aligned with coordinate axes, ray intersecting the box is cheap. Can also use bounding spheres.

These are good when objects are clustered, and not good when they're regularly spaced out or characterized by complex shapes. 

=== Spatial subdivision
Divide space into subregions (voxels), place objects from the scene in the appropriate subregions (voxel), then when tracing a ray only intersect with objects in the subregions which the ray passes. You can think of it via the DDA I think to determine which box to select and then within that box, do ray intersection with the included objects.

#image("../assets/spatial-subdivision.png")

These can also be adaptive, such as with an octree algorithm. 

Tree-based approaches work well for scenes with varying occupancy, so rays can traverse large quantities of empty space with fewer stepping operations. The point where a tree vs grid is more efficient depends n the specific $N$ for the break-even point. For simplicity grids are better, but generally, grid-based approach is better for small number of objects and tree-based for larger.

== Distributed Ray Tracing
/ Distributed Ray Tracing: Instead of adding multiple rays, stochastically perturb the rays according to material scattering properties to simulate phenomena like translucency, glossiness, soft shadows, depth of field, and motion blur. 

- Gloss/Translucency: Perturb reflection/refraction of "ideal" reflection/transmitted rays
- Soft shadow: Perturb shadow rays by sampling their destination on the area sources using similar approaches to sample rays' traversing positions on pixels. (basically, slightly change the direction to another point on an area light)
- Depth of field: Instead of virtual pinhole camera, consider virtual camera with a lens, and perturb primary rays according to optical parameters.
- Motion blur: Perturb primary rays by time. 

== Rendering equation
$L(x, phi, lambda) = L_e (x, phi, lambda) + L_p(x, phi, lambda)$ which means total radiance on point $x$ in direction $phi$ at wavelength $lambda$ equals emitted radiance plus propagated radiance. 

We usually input $L_e$ for our scene, and the $L_p$ is computed in our ray tracing framework. 

$L_p(x, phi, lambda) = integral_("incoming" phi_i) f(x, phi, phi_i, lambda) L_i (x, phi_i, lambda) cos theta_i d arrow(omega_i)$

$theta_i$ is angle between surface normal at $x$ and direction $phi_i$ and $d omega_i$ is differential solid angle where $L_i$ arrives.

#image("../assets/rendering_equation_diagram.png")

This generally has no analytic solution, so we use numerical approximation, either deterministic ones or probabilistic stochastic methods. Ray tracing is a stochastic method. 

Recursively, it is defined as 
$L_r(x, phi) = L_e(x, phi) + f_r(x, phi, phi_i)L_e(x', phi') + f_r(x, phi, phi_i)f_r(x', phi', phi_i')L_e(x'', phi'') + dots$

where each term is the total radiance from emitted surfaces after "x" bounces. This principle equally applies to transmitted rays. Each ray bounce can be seen as a state of a random walk. 

== Path Tracing
In standard ray tracing, a ray path can either be a reflected or transmitted ray, and there can be a shadow ray. This means that after many intersections you will increase the number of rays per eachintersection (1 reflected, 1 transmitted, 1 shadow etc) increasing it exponentially. 

/ Path Tracing: An extension of the ray tracing where we only follow the most probable path at each intersection and shoot a ray toward the light source. (So 1 new ray + 1 shadow ray)

This is great because the first intersections provide the most value to the final pixel colour. Doing more work after many intersections is a bad idea. It's also why a ray hit counter is used to stop recursion after a few bounces.

Path tracing corresponds to a stochastic solution of the rendering equation using Monte Carlo methods, where you imploy importance sampling. 

/ Importance sampling: Estimate the expected value of a function and it prioritizes paths that selects ray directions based on Probability density function matching shape of lighting contribution. 

#image("../assets/importance-sampling.png")

This procedure doesn't apply to diffuse sampling. 

You can also do path tracing by assigning a weight $w$ to each ray, which is analogous to its attenuation level. Initially set to $w = 1$, when a ray with weigh $w$ hits a specular material, same procedure is employed, but reflected and transmitted rays are followed with weights assigned to $w F_r$ and $w(1-F_r)$ respectively. Thus instead of using a hit counter, compare the weight of a ray with a user-specified threshold value $V$. If $w < V$ then random walk is terminated. 

The path tracing approach can be extended to perform plausible simulations of light-material interactions, like a diffuse wood surface covered by a dielectric polish. When the ray hits interface between air and polish, you compute the Fresnel coefficient and compare with random number before deciding to follow reflected or transmitted ray. Thes can then be displaced using Monte Carlo methods. This can help with the realism.