= Overfitting
If big discrepancy in accuracy between training and testing, then we're "overfitting"

== Problems
If training is too small, it's overfitting. If test error is much bigger than training error.

=== Solutions
*Validation*: Keep subsection of testing error as validation error to determine proper hyperparameters, then finally we test to determine the correctness.
*Regularization by Weight Decay*: Expand error to worry about hyperparameters as well. $accent(E, tilde)(accent(y, hat), t; theta) = E(accent(y, hat), t; theta) + lambda/2 norm(theta)_F^2$ Then new rules are $gradient_(theta_i)accent(E, tilde) = gradient_(theta_i)E + lambda theta_i$ and $theta_i arrow.l - kappa gradient_(theta_i) E - kappa lambda theta_i$
*Data Augmentation*: Add slightly modified versions of data to make more samples
*Dropout*: Drop some random nodes to distribute computation. 