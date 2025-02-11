= Neural Nets w/w Auto-Diff
*Pseudocode*:
- Initialize $v, kappa$
- Make expression graph for $E$
- Until convergence:
  - Evaluate E at $v$
  - Zero-grad
  - Calculate gradients
  - Update $v arrow.l "v" - kappa "v.grad"$