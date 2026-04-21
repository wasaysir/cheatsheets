= Colour
/ Trichromatic Theory: Explanation of colour vision at photoreceptor level, based on the three types of cones that exist within the retina.
/ Opponent-process Theory: Explanation of colour vision based on how they're interconnected neurally.

Light reaches our eye as a spectral signal, which is then reduced to three-dimensional colour by our visual system. Try to keep spectral information as long as possible, until it's mapped to display.

The light reaching our eyes is essentially an inner product (reduction of vector into a scalar) over visible spectrum $V$ of input stimulus ($L_p(lambda)$) projecting onto cones with specific wavelengths of stimulus (long, medium, and short). It's expressed as $vec(l, m, s) = integral_V L_p(lambda) vec(overline(l)(lambda), overline(m)(lambda), overline(s)(lambda)) d lambda$

Each colour can be combined additively to give the same colour as an arbitrary source. This is the *additive theory* of light, whereas *subtractive theory* applies to materials where each object further absorbs more wavelengths of light.

/ 1931 CIE XYZ: Tristimulus colour space that provides coefficients with non-negative values for all perceivable colours with functions analogous to sensitivities of the cones. Basically the above but with $X,Y,Z$, and is represented discretely as $vec(X, Y, Z) = vec(overline(x), overline(y), overline(z)) L_p$

#image("../assets/cie-chromaticity.png")

/ Spectral locus: Perimeter of CIE Chromaticity diagram, representing pure monochromatic light by wavelength.
/ Line of purples: Fully saturated colours only made by mixing red and blue. Colours are represented by coordiantes as (x, y, z), these coordinates are converted into CIE XYZ tristimulus values as $x = X / (X + Y + Z), y = Y / (X + Y + Z), z = 1 - x - z$

Different display media can reproduce subsets of the colour.
/ Standard illuminant: Theoretical source of visible light characterized by a specific spectral power distribution. These allow comparing colours displayed under different illumination conditions.
Ex. D65 for CRTs, which has a whitepoint of 6500 Kelvin and is slightly warm/yellowish.

Colour specification systems can map spectral information to colour values. These are either device-independent systems, which specifies colour for any arbitrary colour stimulus, or device-dependent like RGB. Device-independent is useful for robustness and high-precision, whereas RGB lacks perceptual uniformity in the specified colours, but is widely used for its simplicity.

To convert $L_p(lambda)$ into RGB, you can convert CIE colour matching functions $overline(x), overline(y), overline(z)$ with transformation matrix to get $overline(r), overline(g), overline(b)$

The matrix $T$ is set according to chromaticity and white point values associated with target display. Start with matrix $A$ where each entry corresponds to chromaticity coordinates of display, then use that matrix's inverse on a normalized white-point of the monitor, and use that as a diagonal matrix and finally $T = (A C)^(-1)$. Then $R = integral^(720 n m)_(380 n m) L_p(lambda) overline(r)(lambda) d lambda$ and similarly for other colour channels. These are usually replaced by summations as input stimulus is discretized.

