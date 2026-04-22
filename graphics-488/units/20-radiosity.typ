= Radiosity
/ Light: Form of electromagnetic radiation, distinguished by its wavelength $lambda$.

Geometrical optics (treating light as a ray) and radiative transfer theory (describing ray as a beam of energy) are the two physical theories of light commonly used in graphics.

Light transfer simulations in graphisc are further simplifications using similar probability tools.

Light emission is divided by thermal and luminescent emissions. Thermal are due to materials radiating heat energy in the form of light (ex. incandescent light bulb) where temperature corresponds to light emission. Luminescent light emissions are due to energy arriving from elsewhere, stored in material and emitted as photons.

Another simplification in light transport simulations is that energies are independent of the wavelength it's associated with.

In graphics we assume light coming from a light source isn't subject to scattering phenomena (photons deflecting through collisions with material particles).

== Radiometric quantities
/ Spectral: A characterization of a quantity at a specific wavelength $lambda$
/ Radiant Energy: Amount of energy in a packet of rays (represented by $Q$ and measured in Joules).
/ Radiant Power/Flux: The rate of energy flow hitting a surface during a period of time. This radiant power is assumed to be steady. This is denoted by $phi.alt$ and measured in Watts, $W$, or $J s^(-1)$.
/ Radiant Intensity: The amount of radiant power travelling from a source in a certain direction, per unit of solid angle is called the radiant intensity and is denoted by $I$, measured in $W s r^(-1)$
/ Solid Angle: 3D analog to 2D concept of angle. $omega$ solid angle is measured in steradians (radians squared or $s r$) and can be calculated by the area of the sphere it it encloses divided by the radius of the sphere itself.

#image("../assets/solid-angle.png")
#image("../assets/solid_angle_2.png")

Here the same principle applies of solid angle, where the square of the sphere is the area of the sphere it encloses, and the steridians is that area divided by the radius squared. We can calculate that area as $d A = (r d theta)(r sin theta d phi.alt) = r^2 sin theta d theta d phi$, then the differential solid angle is $d omega = (d A)/r^2 = sin theta d theta d phi.alt$

(Note it's $r d theta$ because that's the vertical side length, and $r sin theta d phi.alt$ because that's the horizontal side-length. Note that arc-length is $l = r theta$.

The total solid angle of a sphere is equal to $4 pi$.

/ Radiance: Amount of power arriving at or leaving a surface, per unit solid angle, and per unit projected area. Basically, while solid radiant intensity doesn't care about the radius, radiance does. Measured in $W (s r)^(-1) m^2$

$L(x, phi) = (d I(x, phi))/(d A cos theta) = (d^2 phi.alt(x, phi))/(d omega d A cos theta)$.

- Basically, the intensity over the area of the surface. The cosine term reflects the reduced intensity for when the angle of the emitted light is off from the receiver patch.

#image("../assets/radiance-cosine.png")

/ Radiosity: The radiant flux leaving a surface per unit area of the surface. Basically, this is an area light.

== Material Appearance
/ Measurement of appearance: Group of measurements necessary to characterize a material's appearance through a set of characteristics.
/ Hue: Colour perception attribute denoting red/blue/yellow-ness, etc. of material (What colour is it)
/ Lightness: Attribute distinguishing white from gray and light from dark coloured objects. (How dark is it)
/ Saturation: Degree of departure from gray of the same lightness. (How much colourness can you see)

/ Specular reflection: Perfectly coherent reflection in one angle.
/ Diffuse reflection: Incoherent equal reflection.
/ Glossy reflection: Mixed specular and diffuse reflection.

/ Transparency: Coherent transmission (transmits a ray in one direction)
/ Translucency: Incoherent transmission (transmits a ray in a scattered set of directions)

#image("../assets/transmission-reflection.png")

Material appearance is affected by both specular and spatial distribution, but it's common to quantify these characteristics separately.

/ Reflectance: Fraction of light at wavelength $lambda$ incident at point $x$ that is neither absorbed nor transmitted through a given surface, denoted by $rho(lambda)$. Can be defined as spectral power distribution of reflected light, as in ratio of reflected flux $phi.alt_r$ to incident flux $phi.alt_i$, $rho(lambda) = (phi.alt_r(lambda))/(phi.alt_i(lambda))$

/ Transmittance: Fraction of light transmitted through a material, denoted by $tau(lambda) = (phi.alt_t(lambda)) / (phi.alt_i(lambda))$

/ Absorption: Light that is neither reflected nor transmitted is absorbed. Denoted by $cal(A)(lambda)$

/ Bidirectional Scattering-surface Distribution Function (BSSDF): Composed of BSSRDF and BSSTDF (reflection and transmission components). This function reflects the spatial patterns of light distribution. This is often not practical to use becaues it depends on four parameters: incidence and outgoing directions, wavelength, and position on the surface.

/ Bidirectional Scattering Distribution Function (BSDF/BDF): Simplification of BSSDF that assumes scattering is uniform and dependence of location of reflection can be omitted. This can be decomposed into BRDF and BTDF for reflection and transmittance respectively.

#image("../assets/bssdf.png")

BDF is expressed in terms of ratio between radiance at a surface in direction $phi$ and radiant energy (per unit area and per unit time) incident from a direction $phi_i$ at the surface. $f(phi_i, phi, lambda) = (d L(phi, lambda))/(L_i(phi_i, lambda) d omega_i cos theta_i)$. Note $L_i$ is incident radiance flux. $L(phi, lambda)$ is outgoing ray.

*The BRDF and BTDF components, $f_r, f_t$ are obtained by considering reflection and transmissions directions in the equation $f$*

/ Helmholts Reciprocity Rule: Condition stating that for a particular point and incoming direction and outgoing direction, the BRDF remains the same if the directions were exchanged.

#image("../assets/brdf-reciprocity.png")

This requirement is incredibly important for ray tracing (because of out camera-centric ray tracing)

*The BDFs mut also conserve energy, so total energy propagated in response to some irradiance can't be more than energy received*. Conventionally $rho(phi_i, 2 pi, lambda) = integral_(Omega phi) f_r(phi_i, phi, lambda) cos theta d omega lt.eq forall phi_i$ Basically over all solid angles, ratio of reflection can't be more than one for all light sources. Occurs for reflectance and transmittance.