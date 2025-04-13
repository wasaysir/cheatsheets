= Transformers

First inputs of sequential data are tokenized (converted to vector embedding)

Input $X = (arrow(x_1), dots, arrow(x_n))$
Queries (Input Value): $arrow(q_i) = arrow(x_i) W^((Q)) in RR^(n times l)$
Keys (Tag for data): $arrow(k_i) = arrow(x_i)W^((K)) in RR^(n times l)$
Values (Desired data): $arrow(v_i) = arrow(x_i)W^((V)) in RR^(n times l)$

Let $W^((Q)), W^((K)), W^((V)) in RR^(d times l)$, $l$ is hyperparameter and $arrow(x_i) in RR^d$

We then vectorize components to get $Q = X W^((Q)), K = X W^((K)), V = X W^((V))$ to compute self-attention. 

== Calculating Attention Scores

$S_(i j) = arrow(q_i) dot arrow(k_j)$ which scores query $i$ against key $j$
$S = Q K^T$

We use *softmax* (on each row, set of keys) to get attention scores. $A = "Softmax"(S/sqrt(d)) in RR^(n times n)$ where rows sum to $1$ because of softmax.

Then $H = A dot V, H in RR^(n times l)$, where $H$ is an attention head and $arrow(H_i) = sum^n_(j=1)A_(i j) arrow(v_j)$

To add positional definition, we use positional encodings:

$P E(i)_(2 j) = sin(i/(10000^(2j/d))), P E(i)_(2 j+1) = cos(i/(10000^(2j/d)))$

$P E(i)$ is positional encoding vector for position $i$, frequency changes with dimension $j$ and $10000$ is a scaling constant to allow covering a large max sequence length.

Then $arrow(x_i)' = arrow(x_i) + P E(i)$

\ Multi-Head Attention: Model has separate attention mechanisms learning separate features. Output is concatenated at the end before being linearalized for output.

== Transformer Architecture

Use encoder as layers of multi-head self-attention and fully-connected FF nets and connect to decoder with masked multi-head attention, encoder-decoder attention and fully-connected layers.

#image("../assets/transformer_architecture.png")

