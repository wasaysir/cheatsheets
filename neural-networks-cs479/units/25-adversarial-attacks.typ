= Adversarial Attacks

Consider classifier $f$ that produces probability vectors.

Classificaiton errors are defined as $R(f) eq.delta EE_((x, t) tilde D) ["card"{arg max_i y_i eq.not t | y = f(x)}]$

$epsilon$-Ball: $Beta(x, epsilon) = {x' in X | norm(x - x') lt.eq epsilon}$

Adversarial Attack: Find $x' in Beta(x, epsilon)$ such that $arg max_i(y_i) eq.not t$ for $y = f(x')$

Untargeted Gradient-Based Whitebox Attack: $x' = x + k gradient_x E(f(x; theta), t(x))$
Targeted: $x' = x - k gradient_x E(f(x; theta), l)$

== Fast Gradient Sign Method
Adjust each pixel by $epsilon$, so $delta x = epsilon "sign"(gradient_x E)$ (This is because it's non-differentiable, so model training can't adjust for it)

\ Minimal Perturbation: Smallest $norm(delta x)$ causing misclassification: $min_(norm(delta x))[arg max_i(y_i(x)) eq.not t(x)]$