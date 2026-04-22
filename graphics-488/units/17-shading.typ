= Shading

The point of shading is to take the colour from the illumination model to "shade" (come up with a new colour) for all rasterized pixels on the polygon. 

/ Flat Shading: Apply the same colour to each rasterized pixel on the polygon. Calculate lighting at center of polygon using its normal. 

/ Interpolation-based shading: Contain illumination parameters for each polygon vertex (e.g. normal vectors) and use these to interpolate values on point inside polygon and evaluate colour at that point.

== Gouraud Shading
Interpolate colours across a polygon from the vertices. Lighting calculations only done at the vertices, and use triangle interpolation via Barycentric combinatoins.

/ Barycentric combinations: Point within a triangle is referenced as a weighted average of points within that triangle. 

#image("../assets/barycentric.png")

To slice a polygon with 3+ vertices, sort vertices by y coordinates, then slice polygons into trapezoids with parallel top and bottom, and interpolate colours along each edge of the trapezoid. This unfrotuantely gives shading that is non-invariant under rotation, because shading depends on rotation-dependent slicing.

Alternatively we can use bilinear interpolation for quadrilateral patches.

#image("../assets/bilinear-interpolation.png")

This can lead to Mach band effect, where humans can tell the first order derivative of radiance is changing.

#image("../assets/mach-band.png")

== Phong Shading
/ Phong Shading: Interpolation of lighting model parameters, not colours. Each normal is specified at the vertex of a polygon, and they're independent of the polygon normal. The normal is interpolated across the polygon (using Gouraud techniques), then you interpolate other shading parameters to evaluate lighting model at that point. 

The issues with phong shading are that because it requires normals (which are lost after projection) you have to perform the lighting calculations before perspective transformations, or map the point of interest backwards through perspective transformation, which may not occur if the perspective matrix doesn't have an inverse. Also some vertices can be shared with two or more triangles, so some vertices can have multiple normals leading to inconsistent normal values and ambiguous evaluations at illumination model.