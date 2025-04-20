= Overfitting
Overfitting: Big discrepancy in accuracy between training and testing or wayyyy too small training error.

*Validation*: Keep subset of training set to optimize proper hyperparameters before test.
*Weight Decay*: Change loss to consider hyperparameters. $accent(E, tilde)(accent(y, hat), t; theta) = E(accent(y, hat), t; theta) + lambda/2 norm(theta)_F^2$ Updates are $gradient_(theta_i)accent(E, tilde) = gradient_(theta_i)E + lambda theta_i$ and $theta_i arrow.l - kappa gradient_(theta_i) E - kappa lambda theta_i$ \
*Data Augmentation*: Generate samples by slightly modifying inputs \
*Dropout*: Drop random nodes to distribute computation. 