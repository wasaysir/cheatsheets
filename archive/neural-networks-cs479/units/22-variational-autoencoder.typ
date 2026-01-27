= #link("https://lilianweng.github.io/posts/2018-08-12-vae/#vae-variational-autoencoder")[Variational Autoencoders]

Goal: Autoencoder that generates reasonable samples not in training set by encoding latent probability distribution.

Input: $x$. Latent space: $z$. Encoding: $p(z)$. Decoding: $d(z, theta)$. Want $max_theta p(x) = integral p_theta(x | z) p(z) d z$ (decoding probability)

#box(
  image("../assets/vae_distribution.png", width: 50%)
)

Assume $p(x | z)$ is Gaussian, then NLL is $-ln p_theta(x | z) = 1/(2 Sigma^2) norm(X - d(z, theta))^2 + C$ to maximize. Our goal is $max_theta EE_(z tilde p(z)) [p_theta (x | z)]$ Since we don't know how to sample $p(z)$, we assume distribution $q(z)$ to approximate value. 

$p(x) &= EE_(z tilde p)[p(x | z)] &&= sum_(z tilde p) p(x | z) p(z) \
&= sum_(z tilde q) p(x | z) (p(z))/(q(z)) q(z) &&= EE_(z tilde q)[p(x | z) ((p(z))/q(z))]
$

Then NLL is: $-ln p(x) lt.eq - EE_(q(z))[ln p(x | z)) + ln (p(z))/(q(z))]$, by Jensen's inequality (If f is convex, $E f(x) gt.eq f(E x)$). \
Then we simplify to $-ln p(x) lt.eq K L (q(z) || p(z)) - EE_(q(z))[ln p(x | z)]$. \
$K L(q(z)||p(z)) = -EE_(z tilde q)[q(z) ln ((p(z))/(q(z)))]$.

Then choose $p(z) tilde cal(N)(0, I)$ and we want to $min_q K L (q(z))||cal(N)(0, I))$. Our encoder will be designed to have outputs $mu, sigma$ (not actual mean/std.dev) just parameters for distribution.

Note: $K L (cal(N)(mu, sigma))||cal(N)(0, I)) = 1/2(sigma^2 + mu^2 - ln(sigma^2) - 1)$

Note: $EE_q [ln p(x | z)]$ can be written as $EE_q [ln p(x | accent(x, hat))]$ where $x = d(z, theta)$ and $z = mu(x, theta) + epsilon dot.circle sigma(x, theta)$. This reparameterszation trick was done so we can backprop on $x, theta$, by making the $epsilon$ a separate noise vector. 

Procedure: 
1. Encode $x$ by finding $mu(x, theta)$ and $sigma(x, theta)$
2. Sample $z = mu + epsilon sigma, epsilon=cal(N)(0, I)$
3. Calc KL Loss $1/2 (sigma^2 + mu^2 - ln sigma^2 - 1)$
4. Decode $hat(x) = f(x, theta) = d(z)$ using decoder
5. Calc loss ($L(x, hat(x)) = 1/2 norm(hat(x) - x)^2$ for Gaussian; $sum_x x ln hat(x)$ for Bernoulli)
6. Gradient descent on $E = EE_x [L(x, hat(x)) + beta(sigma^2 + mu^2 - ln sigma^2 - 1)]$