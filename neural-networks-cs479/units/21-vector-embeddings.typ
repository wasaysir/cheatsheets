= Vector Embeddings

Vocabulary inputs can be represented as one-hot vectors. Semantic relationships between words are captured by identifying frequently co-occurring word pairs within a fixed window. A 3-layer neural network predicts these co-occurrences from a one-hot input vector, with the lower-dimensional hidden layer forming the "embedding" where similar words have similar representations. Output is probability of each word's co-occurrence.    

word2vec is a common embedding strategy that treats common phrases as single words, randomly ignores very frequent words, and backpropagates only some negative cases to speed learning.  This trains words by sampling instances where contexts differ to increase reflexive semantic relationships.    

Cosine Similarity uses the cosine angle to measure the distance between vectors in embedding space.  Vector Arithmetic allows for semantic calculations (e.g., King - Man + Woman = Queen).