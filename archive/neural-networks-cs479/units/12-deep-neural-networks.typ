= Deep Neural Networks
/ Vanishing Gradients: When weights and biases are too high, the input currents become too high, and then derivatives are too small, so when you chain them across multiple layers, the gradients reduce severely. $sigma'(z) = sigma(z)(1 - sigma(z))$ with max 0.25, so when chained, each layer shrinks by factor of 4. So the closer the layer to the input, the smaller the gradient.

/ Exploding Gradients: If weights are large and biases position the inputs in the high-slope region of the logistic function, then each layer can amplify the gradient, causing exploding gradients.