= Transformers
Used for predicting sequential data

#image("../assets/transformer.png")

== Input Embedding

\ Input Embedding: Input tokens are mapped to dense vector representations using an embedding layer. $W_0 in RR^(N_"dict" times d)$ $N_"dict"$: Vocabulary Size. $d$ is embedding dimensions.

$W_0$: Learnable lookup table, where embeddings learned iteratively.

== Positional Embedding

\ Positional Embedding: To encode positional data, the vector is encoded based on its position within the string into a series of sin and cosine frequencies, which is beneficial because it is normalized and restricted, allowing invariance between varying length strings, but also ensuring positional value.

Positional Encoding formula: $P E_("pos", 2i) = sin("pos"/10000^(2i/d)_"model")$ and $P E_("pos", 2i + 1) = cos("pos"/10000^(2i/d)_"model")$

#image("../assets/positional-embedding.png")

Helps model adapt and capture sequential patterns in data. Note that positional encoding can be learned as part of model's parameters.

== Attention

Compared to fixed-weights from NNs, Attention dynamically computes weights based on input values.

Attention is conceptually a soft lookup table, retrieving relevant information based on learned similarity.

$"Attn"(q, (k_(1:m), v_(1:m))) = sum_(i=1)^m alpha_i(q, k_(1:m)) v_i$ The attention weights are computed by query-key similarity.

#image("../assets/attention-mechanism.png")

$q$ is query (current token input), $k$ is previous set of inputs, $v$ is previous set of computed encoded values.

Attention weights are derived from attention score function, which measures similarity between query and each key. Then attention weights are computed using softmax function. Attention weight $alpha_i = alpha_i (q, k_(1:m)) = "softmax"_i([a(q, k_1), dots, a(q, k_m)])$ where $a$ is attnetion score function.

Generally, attention is represented as:
$Z = Phi(W(Q, K)V)$ where $Q in RR^(n times d_q)$ are queries, derived from $X$, describing what each input is "looking for"

$K in RR^(m times d_q)$ are keys, derived from $X$, describing what each input vector contains.

$V in RR^(m times d_v)$ are values, indicating how each input should be transmitted to the output.

Typically these values are found as linear projections of input: $Q = X W_q, K = X W_k, V = X W_v$

When computing attention over mini-batches of $n$ input vectors, the attention-weighted output is: $"softmax"((Q K^T)/sqrt(d))V in RR^(n times d_v)$ where softmax is applied row-wise, for parallelism. (We scale by $sqrt(d)$ to reduce exploding gradients.)

== Multi-Head Attention
Instead of single attention function we can use multiple projections to learn different dependencies.

$T_i = "softmax"((X W^i_q(X W^i_k)^T)/sqrt(d)) X W^i_v$

Then, the output is $"MHA"(X) = "Concat"(T_1, dots, T_h) W_o$

#image("../assets/multi-head-attention.png")

== Residual Connections
To avoid vanishing gradients in deep networks, residual connections allow gradients to bypass layers. Ex: $f_l'(x) = F_l(x) + x$ allows the network to learn a residual correction instead of a full transformation, creating stable optimization and deeper networks. $f'_l(x) = F_l(x) + x$

== Layer Normalization
$accent(x_i, hat) = (x_i - mu_L)/(sqrt(sigma^2_L + epsilon)), y_i = gamma accent(x_i, hat) + beta$ where $mu_L, sigma_L$ are mean and variance of activations, and $gamma, beta$ are learnable parameters.

Each Transformer block contains feedforward Multi-Layer-Perceptron:
z = LayerNorm(x + MultiHeadAttention(x)) \
z = LayerNorm(z + MLP(z))
The MLP captures more complex dependencies and transformations.

#image("../assets/transformer2.png")