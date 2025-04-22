= Transformers

Sequential data inputs are first tokenized into vector embeddings. The input $X$ is transformed into queries (input values) $Q = X W^((Q))$, Keys (tags) $K = X W^((K))$, and values (desired data) $V + X W^((V))$ using weight matrices $W^((\_)) in RR^(d times l)$

Self-attention scores are calculated $S = Q K^top$ where $S_(i j) = q_i dot k_j$ scores query $i$ against key $j$. Softmax is applied row-wise to $S/sqrt(d)$ to get attention scores $A in RR^(n times n)$. Output of attention head is $A dot V = H in RR^(n times l)$

Positional encodings:$P E(i)_(2 j) = sin(i/(10000^(2j/d))), P E(i)_(2 j+1) = cos(i/(10000^(2j/d)))$ freq changes with dimension $j$, and $10000$ is scaling constant for large max seq len. Then, $arrow(x_i)' = arrow(x_i) + P E(i)$

Multi-Head Attention uses separate attention mechanisms to learn different features, then outputs are concatenated and linearized for output.
