= Adversarial Defense

During training, add adversarial samples to dataset with proper classification.

== TRADES
Model: $f: X arrow RR$
Dataset: $(X, T); X in XX, T in {-1, 1}$
$"sign"(f(X))$ indicates class. Classification is correct if $f(X)T > 0$

Robust Loss: $cal(R)_("rob")(f) = EE_(X, T)["card"{X' in Beta(X, epsilon) | f(X')T lt.eq 0}]$ (Even if proper classification, if $epsilon$-ball can be fooled, it counts for loss)

Differentiable Training Loss: $cal(R)_"learning" = min_f EE_((X, T))[g(f(X))T]$ where $g$ is smooth function.

Robust model optimizes over $min_f EE_((X, T))[g(f(X)T) + max_(X' in Beta(X, epsilon)) g(f(X)f(X'))]$
Term 1 ensures proper classification. Term 2 adds penalty for attacks.

Procedure:
+ For each gradient update:
  + Run several gradient ascents to find $X'$
  + Evaluate joint loss $g(f(X)T) + beta g(f(X)f(X'))$
  + Update weights off loss