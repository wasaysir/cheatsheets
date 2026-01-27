= Autoencoders

Neural network that learns to encode/decode a set of inputs automatically into a smaller latent space.

The model is trained using loss function minimizing $L(x', x)$ where $x'$ is reconstructed input and $x$ is original input.

To simplify latent space encoding, we can tie the weights of the encoder and decoder, so that the encoder weights are $W$ and the decoder weights are $W^T$