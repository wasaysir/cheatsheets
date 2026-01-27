= Batch Normalization

Some input features will have dramatically different magnitudes than others. But we'd need to accomodate the smallest magnitude feature to make meaningful steps, which slows down the larger magnitude rate.

The goal is to rescale all hidden layer outputs into normalized values.

Use the standard formulas for means and variance for each hidden layer output, then we rescale the inputs into the next layer as:

$accent(h_i, hat)^((d)) = (h_i^((d)) - mu_i)/sigma_i$ or $accent(h_i, hat)^((d)) = (h_i^((d)) - mu_i)/sqrt(sigma_i^2 = epsilon)$ for small $epsilon > 0$ for if variance is 0, to prevent instabilities.

Then we rescale output with learnable parameters $gamma_i, beta_i$

Following process: [Hidden layer i] -> Normalization -> Rescaling -> [Hidden Layer i+1]

$y_i^((d)) = gamma_i accent(h_i, hat)^((d)) + beta_i$

Batch normalization affects convergence rate for learning quickly. 
The reason is unknown but there are hypotheses:
- Mitigates vanishing/exploding gradients
- Guards against internal covariate shift (shallow layers (near output) learn quicker than deep layer, so whenever deep layers learn, they invalidate the outputs of the shallow layer, who has to learn again. By normalizing, the inputs remain relatively stable, so shallower layers aren't as "affected" by differences from deep layer changes.