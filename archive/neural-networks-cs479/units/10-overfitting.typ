= Overfitting
Overfitting: Big discrepancy in accuracy between training and testing or wayyyy too small training error.

*Validation*: Subset of training set for optimizing hyperparameters. *Weight Decay*: Loss considers hyperparameters. $accent(E, tilde)(accent(y, hat), t; theta) = E(accent(y, hat), t; theta) + lambda/2 norm(theta)_F^2$ Updates are $gradient_(theta_i)accent(E, tilde) = gradient_(theta_i)E + lambda theta_i$ and $theta_i arrow.l theta_i - kappa gradient_(theta_i) E - kappa lambda theta_i$ \ *Data Augmentation*: New samples by slight changes. *Dropout*