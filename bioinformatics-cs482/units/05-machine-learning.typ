= Machine Learning

\ Dimensionality Reduction: Reduce higher-dimensional data into lower-dimensions to reduce the effect of noise and irrelevant features to create a more robust representation of data patterns.

\ Representation Learning: Find data representations in lower dimensions by finding patterns in large datasets. 

Use case example: From Raw Data derive a feature representation. Then, from those features create a task-specific model to solve some problem. We lower our complexity by abstracting away the raw data.

\ Traditional Feature Engineering: Manually designed features tailored for specific tasks.

Traditional Feature Engineering vs Representation Learning: The features are either given (by domain knowledge) or found (by computation)

\ Feedforward Neural Networks: Layers of interconnected neurons, where each layer's output is passed to the next. Perfect for dense, unstructured data with fixed set of features.

\ Convolutional Neural Networks: Fits structured data with spatial bias (data points "near each other" are related). Each convolutional filter captures local features in a fixed input size. 

\ Convolution Pooling: Pooling is the method of reducing the dimension of information for a region of information. Reduces computation and overfitting by *downsampling* feature maps. 

\ Max Pooling: Return maximum value within a region
\ Average Pooling: Return average value within a region.

*Convolutional Neural Networks Hyperparameters*:
\ Kernel Size (k): Size of kernel
\ Stride (s): Step size for moving filter
\ Padding (p): Number of zero-padded pixels to input

*Output Size*: $floor(("Input Size" + 2p  - k)/s) + 1$

#table(
  columns: 5,
  table.header([],[Inputs], [Specialty], [Advantages], [Limitations]),
  [FNNs], [Fixed Features], [Unstructured Data], [Simplicity], [No spatial/temporal relat.],
  [CNNs], [Structured Data], [Spatial/Local patterns], [Spatial bias], [Fixed input size],
  [Transformers], [Sequential Data], [Temporal Dependencies], [Long-range dependencies], [Computational Cost]
)

== Optimization Methods
\ Stochastic Gradient Descent: Updates are based on gradient of loss for randomly selected mini-batch. $theta arrow.l eta gradient_theta cal(L)(theta; beta)$.

\ Momentum: Gradient Descent + considers past gradients to find smooth updates and prevent oscillations.

$v_t = beta v_(t-1) + (1 - beta) gradient_theta cal(L) theta$
$theta arrow.l theta - eta v_t$

\ Adam Optimizer: Combines momentum with adaptic learning rates for parameters. Best for sparse data.

$m_t = beta_1 m_(t-1) + (1 - beta_1) gradient_theta cal(L) theta$
$v_t = beta_2 v_(t-1) + (1 - beta_2) (gradient_theta cal(L) theta)^2$
$theta arrow.l theta - eta m_t/(sqrt(v_t) + epsilon)$

\ AdamW Optimizer: Adam but with a weight regularization term. Best for large models (improves generalization through weight regularization term)
$theta arrow.l theta - eta (m_t/(sqrt(v_t) + epsilon) + lambda theta)$

== Normalization

\ Batch Normalization: Normalize input across inputs in batch to generalize inputs

$accent(x_i, hat) = (x_i - mu_B)/(sqrt(sigma^2_B + epsilon))$ $y_i = gamma accent(x_i, hat) + Beta$

$mu_B, sigma_B$ are batch mean and variance, and the others are learnable parameters.

\ Layer Normalization: Normalize across features (within one sample, normalize features) to improve sequential model performance.

$accent(x_j, hat) = (x_j - mu_L)/(sqrt(sigma^2_L + epsilon))$ $y_j = gamma accent(x_j, hat) + Beta$

$mu_B, sigma_B$ are sample mean and variance.