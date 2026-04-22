= Illumination Models
Ray tracing holistically has a general set of steps to produce an image:
+ Geometry
+ Sample light sources
+ Compute local interactions of light with surface
+ Compute global interactions of a light ray throughout a scene
+ Tone map the spectral signals into display values

== Lambertian Reflection
/ Lambertian model for diffuse materials: A perfect diffuse assumes light is propagated equally in all directions, and amount of light is propagated directly proportional to $cos theta_i$ (angle between incidnet ray and normal)
#image("../assets/lambert-model.png")

/ Irradiance: Energy received at surface. 

Irradiance E for a surface is equivalent to $E_"in"(arrow(l)) = L_"in"(arrow(l)) (delta A_"in")/(delta A_"surf")$

Sometimes the input area of light is at an angle with the normal, so the amount of light is reduced, therefore you can calculate the above fraction of $(delta A_"in")/(delta A_"surf") = cos(theta_"in") = arrow(l) dot arrow(n)$

The outgoing amount of light is given by $L_"out"(arrow(v)) = rho(arrow(v), arrow(l)) E_"in"(arrow(l))$.

Since we assume equal radiance in all directions, $rho$ is a constant, modelled by $k_d$. If $k_d in [0, 1]$ a factor of $pi$ is necessary to our $L_"out"(arrow(v))$ equation to ensure conservation of energy.

As a consequence, BRDFs of a perfect diffuse material are given by $rho / pi$ where $rho$ is material's reflectance. 

The model is expressed as $L_"out"(phi, lambda) = rho(lambda) L_"in"(phi_i, lambda) cos theta_i$, $phi$ is propagated angle and $phi_i$ is incident direction. Similar model can simulate diffuse transmission by considering transmittance instead of reflectance.

Simply: $L_"out"(arrow(v)) = k_d L_"in"(arrow(l))(arrow(l) dot arrow(n))$, $k_d$ is diffuse coefficient, and $arrow(l)$ is incident ray. 

*To simulate perfect specular light propagation, use law of reflection for reflected vctor. For coherent transmission, apply Snell's law*

/ Phong Model: Local illumination model that marries specular and diffuse material. 

== Attentuation
Two types of lights:
- Directional
- Point
- Directional light sources have parallel rays, which is appropriate for distant light sources (sun) and there's no attenuation as energy doesn't "spread out"

Point light sources emit light equally in all directions. Conservation of energy tells us $L_"in"(arrow(l)) prop I/r^2$ where $r$ is distance from light to point $P$, $I$ is light source intensity. 

This $r^2$ attenauation can be too harsh because real lighting comes from area sources, so we typically use $L_in(arrow(l)) = I/(c_1 + c_2 r + c_3 r^2)$

=== Colours, Multiple & Ambient light
To get multiple lights, compute contribution from each light source onto the point independently and sum. $L_"out"(arrow(v)) = sum_i rho(arrow(v), arrow(l_i)) I_i (arrow(l_i) dot arrow(n))/(c_1 + c_2 r_i + c_3 r_i^2)$. 

For coloured lights, perform light calculation for each component of an RGB triple.

/ Ambient Light: Simple approximation of global illumination. It's a term you add to $L_"out"$ like $k_a I_a$ based on colour coefficient for ambient light and intensity of ambient light. 

/ Global Illumination: "Indirect illuminaton", how light bounces off surfaces onto other surfaces. Very expensive computationally. 

== Phong Lighting Model
Lambertian illumination models matte surfaces, but not shiny ones. Shiny surfaces have "highlights" depending on viewer's position.

$L_"out"(arrow(v)) = k_a I_a + k_d(arrow(l) dot arrow(n)) I_d + k_s (arrow(r) dot arrow(v))^p I_s$

The vector $arrow(r)$ is $arrow(l)$ reflected by surface, $arrow(r) = - arrow(l) + 2 (arrow(l) dot arrow(n))arrow(n)$

The $p$ component determines sharpness of highlight, small $p$ gives a wide highlight, large $p$ gives narrow highlight (since $arrow(r) dot arrow(v)$ is cosine angle of reflected angle and incident, exponentiated it decays the term, when off-angle, so higher-exponents increases drop-off when not looking at light where it gets reflected.)

*NOTE: THIS DOESN'T FOLLOW ENERGY CONSERVATION*

=== Blinn-Phong Model
Extension of Phong Model. Since Phong can sometimes have $arrow(r) dot arrow(v) > 90 degree$ this becomes negative and adds weird components to our lighting. This extension with the half vector between viewing direction and light-incidence guarantees non-negativity and produces a better image. 

$H = "normalized"(arrow(l) + arrow(v))$ and then $arrow(r) dot arrow(v)$ is replaced with $arrow(n) dot arrow(h)$ in the Phong Illumination model. 

== Optics Concepts

/ Complex Index of Refraction: Characterization of materials for their refraction. Consists of real (refractive index) and imaginary term (extinction coefficient). Represented by $N(lambda)$

/ Refractive index: $eta(lambda)$ shows how much light wave slows relative to speed in vacuum. 
/ Extinction coefficient: Shows how easily light wave peentrates into medium. $k(lambda)$

$N(lambda) = eta(lambda) + j k (lambda)$, $j = sqrt(-1)$ (imaginary unit)

/ Semi-conductors: Materials with small extinction coefficient
/ Dielectrics: Non-conductors whose extinction coefficient is by definition 0. 

=== Reflection law
When light hits smooth surface, reflection direction $theta_r$ is equal to angle of incidence $theta_i$ and will be in same plane as incident direction. $theta_r = theta_i$. 

You can derive angle $theta_i = arccos((arrow(n) dot arrow(i)) / (abs(arrow(n)) abs(arrow(i))))$

The horizontal component of incident ray $arrow(i)$ is $sin theta_i arrow(n) = arcsin((arrow(n) dot arrow(i)) / (abs(arrow(n)) abs(arrow(i)))) arrow(n)$, vertical is the arccos equivalent. 

The reflected ray will have the same horizontal direction, but the vertical direction will be opposite, so you add the horizontal component to the vertical component of the incident ray, this is equivalent to adding the horizontal component twice, thus you get:
$arrow(r) = arrow(i) + 2 arrow(n) cos theta_i = arrow(i) - 2 arrow(n) (arrow(i) dot arrow(n))$

=== Transmission law
#image("../assets/transmission-law.png")
Transmission direction is given by Snell's law, $eta_i sin theta_i = eta_t sin theta_t$, so transmission direction $arrow(t) = - arrow(n) cos theta_t + arrow(m) sin theta_t$ where $arrow(m)$ is vector perpendicular to $arrow(n)$ in same plane as $arrow(i)$ and $arrow(n)$

Note that angle of transmission becomes $90 degree$ when $theta_i$ equals critical angle $theta_c = arcsin(eta_t / eta_i)$, at all polar angles of incience greater than critical angle, incident light is reflected back to incident medium, causing *total internal reflection*

Incident rays aren't just reflected or transmitted at an interface between dielectrics, but attenuated, which is given by Fresnel coefficients for reflection and transmission. 

/ Attenuation: Gradual loss of intensity as a wave travels through a medium.