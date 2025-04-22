= Diffusion Models

Generative model using noise as seeds for making new images, by training on a model that adds noise to samples so it can then reverse the process.

#image("../assets/diffusion_direction.png")

Forward process: $q(x_t | x_(t-1)) = cal(N)(x_t; sqrt(1 - beta_t)x_(t-1), beta_t I)$. Final state is pure noise ($x_T tilde cal(N)(0, I)$). The variance schedule $beta_1, dots, beta_T$ are hyperparameters controlling noise addition. Usually starts small, gets larger.

If we unwrap $x_t$ recursively, we get $x_t = sqrt(overline(alpha_t))x_0 + sum_i c_i epsilon_i$ where $a_t equiv 1 - beta_t$, $overline(alpha_t) equiv alpha_1 dots alpha_t$ and $epsilon_i tilde cal(N)(0, I)$. Since sum of gaussians is gaussion, then $x_t = sqrt(overline(alpha_t))x_0 + sqrt(1 - overline(alpha_t)) epsilon$.

To get $x_0$ from $x_t$, we use neural net $epsilon_theta (x_t, t)$ to estimate noise $epsilon$

To do reverse diffusion (generate input from noise), we need to minimize KL-divergence loss of $D_(K L) (q(x_(t-1)|x_t, x_0), p_theta(x_(t-1)|x_t))$ for $t=2, dots, T$. $q(x_(t-1)|x_t, x_0) = cal(N)(x_(t-1)|mu_q, Sigma_q), mu_q = 1/(sqrt(alpha_t))(x_t - beta_t/(sqrt(1 - alpha_t)) epsilon_t)$

Further, parameterized probability density $p_theta$ is assumed to be a Gaussian distribution, with the same format, but $epsilon_theta(x_t, t)$ instead of $epsilon_t$

Then the KL-Divergence gets simplified to $EE_(x_0, epsilon)[lambda_t norm(epsilon - epsilon_theta(x_t, t))^2_2]$ where $lambda_t = beta_t^2/(2 sigma^2_t alpha_t(1 - overline(alpha_t)))$. By substituting $x_t$ we get $EE_(x_0, epsilon)[norm(epsilon - epsilon_theta(sqrt(overline(alpha_t))x_0 + sqrt(1 - overline(alpha_t))epsilon))^2_2]$

Training Algorithm:
Repeat until converge:
+ Take $x_0$ from dataset
+ $t tilde$ Uniform({$1, dots, T$})
+ $epsilon tilde cal(N)(0, I)$
+ Do gradient descent on simplified Loss function

Sampling Algorithm:
+ Set $x_T tilde cal(N)(0, I)$
+ For $t = T, dots, 1$
  + $z tilde cal(N)(0, I)$ if $t > 1$ else $z = 0$ We add noise to make stochastic sample
  + $x_(t-1) = 1/(sqrt(alpha_t))(x_t - beta_t/(sqrt(1 - overline(alpha_t))) epsilon_theta(x_t, t)) + sigma_t z$ 
+ Return $x_0$

We typically use a U-net to estimate $epsilon_theta$ because upsampling/desampling works well with noisy data where compressed and original spatial data are both important.