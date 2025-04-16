= Machine Learning

\ Dimensionality Reduction: Reduce higher-dimensional data into lower-dimensions to reduce the effect of noise and irrelevant features to create a more robust representation of data patterns.

\ Representation Learning: Find data representations in lower dimensions by finding patterns in large datasets. Goal is to find task-agnostic features from data without manual design.

Use case example: From Raw Data derive a feature representation. Then, from those features create a task-specific model to solve some problem. We lower our complexity by abstracting away the raw data.

\ Traditional Feature Engineering: Manually designed features tailored for specific tasks.

Traditional Feature Engineering vs Representation Learning: The features are either given (by domain knowledge) or found (by computation)

== Deep Neural Networks
- Neural networks are made of multiple layers. Given input $x$, neural network is $f_theta = f_L circle dots circle f_1$ where $f_1$ is input layer, $f_L$ is output layer, and intermediate layers are hidden layers.

\ Feedforward Neural Networks: Layers of interconnected neurons, where each layer's output is passed to the next. Perfect for dense, unstructured data with fixed set of features.

$h^((l)) = sigma(W^((l)) h^((l-1)) + b^((l)))$

Activation Functions:
- ReLU: $sigma(x) = max(0, x)$
- Sigmoid: $sigma(x) = 1/(1 + e^(-x))$
- Tanh: $sigma(x) = (e^x - e^(-x))/(e^x + e^(-x))$

\ Convolutional Neural Networks: Fits structured data with spatial bias (data points "near each other" are related). Each convolutional filter captures local features in a fixed input size. 

$f^((l))_(i, j) = sigma(sum_u sum_v W^((l))_(u, v) dot h^((l-1))_(i+u, j+v) + b^((l)))$ Basically each filter multiplies the kernel against the "kernel" for each window in the filter, and computes this for all pixels necessary.

\ Convolution Pooling: Pooling is the method of reducing the dimension of information for a region of information, to enhance translation invariance. Reduces computation and overfitting by *downsampling* feature maps. 

\ Max Pooling: Return maximum value within a region
\ Average Pooling: Return average value within a region.

*Convolutional Neural Networks Hyperparameters*:
\ Kernel Size (k): Size of kernel
\ Stride (s): Step size for moving filter
\ Padding (p): Number of zero-padded pixels to input

*Output Size*: $floor(("Input Size" + 2p  - k)/s) + 1$

Padding Strategies:
- No padding ($p = 0$) Output smaller
- Same (padding to maintain size): $p = (k-1)/2$ if $s = 1$

#table(
  columns: 5,
  table.header([],[Inputs], [Specialty], [Advantages], [Limitations]),
  [FNNs], [Fixed Features], [Unstructured Data], [Simplicity], [No spatial/temporal relat.],
  [CNNs], [Structured Data], [Spatial/Local patterns], [Spatial bias], [Fixed input size],
  [Transformers], [Sequential Data], [Temporal Dependencies], [Long-range dependencies], [Computational Cost]
)

Probabilistic Interpretation of Supervised Learning:
- $f(x; theta)$ is conditional probability of target $y$ given input $x$: $p(y | x, theta)$, same as approximating posterior distribution of $y$ given $x$.

\ Universal Approximation Theorem: A sufficiently deep neural network with non-linear activation functions can approximate any continuous function arbitrarily well.

Supervised Learning Outputs: Sigmoid for binary classification, softmax for multi-class classification, identity for regression.

Loss functions in supervised learning: 
- Negative Log Likelihood/Cross-entropy loss (Classification): $cal(L) = - sum^N_(i=1) sum^K_(j=1) tilde(y)_(i j) log p(y_j | x_i, theta)$ where $tilde(y)_(i j)$ is one-hot encoded true lable and $p(y_j | x_i, theta)$ is model's predicted probability.
- Mean Squared Error (Regression): $cal(L) = 1/N sum^N_(i=1) (y_i - hat(y_i))^2$

== Optimization Methods
\ Stochastic Gradient Descent: Updates are based on gradient of loss for randomly selected mini-batch. $theta arrow.l eta gradient_theta cal(L)(theta; beta)$.

\ Momentum: Gradient Descent + considers past gradients to find smooth updates and prevent oscillations and navigating steep ravines and speeding up convergence.

$v_t = beta v_(t-1) + (1 - beta) gradient_theta cal(L) theta$
$theta arrow.l theta - eta v_t$

$v_t$ is velocity, $beta$ is momentum factor, and $mu$ is learning rate.

\ Adam Optimizer: Combines momentum with adaptic learning rates for parameters. Best for sparse data.

$m_t = beta_1 m_(t-1) + (1 - beta_1) gradient_theta cal(L) theta$
$v_t = beta_2 v_(t-1) + (1 - beta_2) (gradient_theta cal(L) theta)^2$
$theta arrow.l theta - eta m_t/(sqrt(v_t) + epsilon)$

$m_t$ is estimate of mean of gradients, $v_t$ is estiamte of uncentered variance of gradients, $beta_1, beta_2$ are control decay rates.

\ AdamW Optimizer: Adam but with a weight regularization term. Best for large models (improves generalization through weight regularization term)
$theta arrow.l theta - eta (m_t/(sqrt(v_t) + epsilon) + lambda theta)$

Choosing Optimizer:
- SGD: Good for simpler models, but slow convergence in complex landscapes
- Momentum: Speeds up convergence by incorporating past gradients
- Adam: Combines momentum and adaptive learning rates, ideal for sparse data
- AdamW: Best for large models; improves generalization with decoupled weight decay

Best to start with Adam for most neural networks; for large-scale fine-tuned models, AdamW is better due to weight decay. Momentum-based SGD is common for image tasks and good generalization. 

\ Transfer learning: After learning, we can use learned representations from intermediate layers to perform other tasks on smaller dataset, transfering knowledge learned from $D$, which is useful for leveraging knowledge from one task to improve performance on another. Good for domains with limited labelled data, like medical imaging. Often involves pre-training a model on a large dataset and then fine-tuning on the target task.

== Normalization

\ Batch Normalization: Normalize input across inputs in batch to generalize inputs

$accent(x_i, hat) = (x_i - mu_B)/(sqrt(sigma^2_B + epsilon))$ $y_i = gamma accent(x_i, hat) + Beta$

$mu_B, sigma_B$ are batch mean and variance, and the others are learnable parameters.

\ Layer Normalization: Normalize across features (within one sample, normalize features) to improve sequential model performance.

$accent(x_j, hat) = (x_j - mu_L)/(sqrt(sigma^2_L + epsilon))$ $y_j = gamma accent(x_j, hat) + Beta$

$mu_B, sigma_B$ are sample mean and variance.