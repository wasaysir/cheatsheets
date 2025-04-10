= Vector Embeddings

Given a set of all inputs in our dataset, we can call this our vocabulary. We can order and index vocabulary into a set of one-hot vectors of the size of our vocabulary.

To reflect semantic relationships between words, we can determine word pairs for words that often occur near each other within some fixed window size $d$. 

With this set of word pairs, we can try to predict these word co-occurrences via a 3-layer neural network. 

Input is a one-hot word vector, output is probability of each word's co-occurrence. 

The hidden layer is of a lower dimensional space, requiring similar words to take similar representations, this is called "embedding". 

*word2vec*: Popular embedding strategy that 1. treats common phrases as words (New York) and 2. randomly ignores very common words (the) and 3. backpropagates only some of the negative cases. in order to speed up the learning. (this means we train our words by sampling instances where contexts are DIFFERENT to increase reflexive semantic relationships)

*Cosine Similarity*: Cosine angle is used to measure "distance" between two vectors in embedding space. (Since they're all )

*Vector Arithmetic*: By applying vector arithmetic, you can do semantic calculations. (Ex. King - Man + woman = )