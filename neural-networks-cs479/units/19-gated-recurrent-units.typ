= Gated Recurrent Units
RNNs can't capture long-range dependencies, because of vanishing gradients, so early tokens have small impact on later. \
Consider $h^n = w h^(n-1) + x^n$. If $abs(w) < 1$ then $w^n$ shrinks exponentially as $n$ grows, early info has less weight on $h^n$ over time. If $abs(w) > 1$, $h^n$ grows exponentially $arrow$ unstable training.

== Gated Recurrent Units
Gate mechanisms control which information to retain.

*Candidate Hidden State*:
$accent(accent(h^n, tilde), arrow) = tanh(accent(h^(n-1), arrow)W + accent(x^n, arrow) U + accent(b, arrow))$. \
$W: "hidden->hidden", U: "input->hidden", b: "bias", tanh: "ensures output" in (-1, 1)$

*Gate Mechanism*:
$accent(g^n, arrow) = sigma(accent(h^(n-1), arrow) W_g + accent(x^n, arrow) U_g + accent(b_g, arrow))$. $sigma$ means $g^n_i in (0, 1)$

*Final Hidden State Update*:
$accent(h^n, arrow) = accent(g^n, arrow) dot.circle accent(accent(h^n, tilde), arrow) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$

$accent(g^n, arrow)$ controls how much of new candidate is retained, and $(1 - accent(g^n, arrow))$ shows how much of previous state is preserved.

When $g = 0$ we don't update hidden state (meaning the word added no new context), if $g = 1$, then we do update, proving it's important information.

== Full GRU
Update + reset gate added same as gate mechanism above. Reset tries to "forget" past hidden state for new candidate. When $accent(r^n, arrow) approx 0$, past is discarded. \
Hidden state update:
$accent(accent(h^n, tilde), arrow) = tanh((accent(h^(n-1), arrow) dot.circle accent(r^n, circle))W + accent(x^n, arrow)U + accent(b, arrow))$

$accent(h^n, arrow) = accent(g^n, arrow) dot.circle accent(accent(h^n, tilde), arrow) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$
== minGRU
For $N$-length sequence, each component computed sequentially with poor parallelization w/w GPUs.
$accent(g^n, arrow) = sigma(accent(x^n, arrow) U_g + accent(b_g, arrow))$ \ 
$accent(accent(h^n, tilde), arrow) = accent(x^n, arrow)U + accent(b, arrow)$ \
$accent(h^n, arrow) = accent(g^n, arrow) dot.circle accent(accent(h^n, tilde), arrow) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$

Parallel Scan: $arrow(h^n) = A^n dot.circle arrow(h^(n-1)) + B^n$. $in Omicron(log N)$