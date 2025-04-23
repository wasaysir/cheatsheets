= Universal Approximation Theorem

$forall f in C(I_n), and epsilon.alt > 0, exists G(x) = sum^N_(j=1) a_j sigma(w_j x + theta_j)$ such that $abs(G(x) - f(x)) < epsilon.alt forall x in I_n$, $I_n in [0, 1]$. $sigma(w x)$ is any sigmoid function, with infinite weight becomes threshold. Piece functions are differences of thresholds.