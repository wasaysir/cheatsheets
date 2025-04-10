= Gated Recurrent Units

== Problem

Vanilla RNNs struggle to capture long-range dependencies, because of the vanishing gradient problem, as gradients multiply over long ranges, meaning the relative effect of distant tokens to the current token are minimal. 

Consider a simple example:

$h^n = w h^(n-1) + x^n$, if we unroll this equation, we get $h^n = w^(n-1)h_1 + w^(n-1) x^1 + w^(n-2) x^2 + dots$

If $abs(w) < 1$ then $w^n$ shrinks exponentially as $n$ grows, meanign earlier information has exponentially less influence on $h^n$ over time. If $abs(w) > 1$ then $h^n$ magnitude grows exponentially, making training unstable.

== Gated Recurrent Units
Use gating mechanisms to control which information to retain.

*Candidate Hidden State*:
Candidate Hidden state $accent(accent(h^n, tilde), arrow)$ is computed as:
$accent(accent(h^n, tilde), arrow) = tanh(accent(h^(n-1), arrow)W + accent(x^n, arrow)U + accent(b, arrow))$. $W: "hidden-to-hidden weights", U: "input-to-hidden weights", b: "bias", tanh: "ensures output" in (-1, 1)$

*Gate Mechanism*:
$accent(g^n, arrow) = sigma(accent(h^(n-1), arrow) W_g + accent(x^n, arrow) U_g + accent(b_g, arrow))$ The sigmoid ensures $g^n_i in (0, 1)$ meaning it's a soft switch. 

*Final Hidden State Update*:
$accent(h^n, arrow) = accent(g^n, arrow) dot.circle (accent(accent(h^n, tilde), arrow)) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$

$accent(g^n, arrow)$ controls how much of new candidate is retained, and $(1 - accent(g^n, arrow))$ shows how much of previous state is preserved.

When $g = 0$ we don't update hidden state (meaning the word added no new context), if $g = 1$, then we do update, proving it's important information.

== GRU Network

The GRU extends from RNN by adding two gating mechanisms, update gate and reset gate (same format as gate mechanism above). 

Hidden state updates as follows:
$accent(accent(h^n, tilde), arrow) = tanh((accent(h^(n-1), arrow) dot.circle accent(r^n, circle))W + accent(x^n, arrow)U + accent(b, arrow))$

$accent(h^n, arrow) = accent(g^n, arrow) dot.circle accent(accent(h^n, tilde), arrow) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$

Reset gate tries to "forget" previous hidden state information for new candidate. When $accent(r^n, arrow)$ is close to 0, past is discarded, making it more focused on recent information, when close to $1$, then more of hidden state is retained. 

== minGRU

For a sequence of length $N$, we'd need to compute each component sequentially, nullifying parallelization advantages from GPUs.

minGRU simplifies to: 
$accent(g^n, arrow) = sigma(accent(x^n, arrow) U_g + accent(b_g, arrow))$
$accent(accent(h^n, tilde), arrow) = accent(x^n, arrow)U + accent(b, arrow)$
$accent(h^n, arrow) = accent(g^n, arrow) dot.circle accent(accent(h^n, tilde), arrow) + (1 - accent(g^n, arrow)) dot.circle accent(h^(n-1), arrow)$

minGRU allows $accent(g^n, arrow) "and" accent(accent(h^n, tilde), arrow)$ to be parallelizable. 
Hidden states can use parallel scan to compute values in $Omicron(log N)$ instead of $Omicron(N)$ sequentially. 