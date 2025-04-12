= #link("https://lilianweng.github.io/posts/2018-08-12-vae/#vae-variational-autoencoder")[Variational Autoencoders]

The goal is to create an autoencoder that can generate reasonable samples not in training set.

We encode a latent probability distribution, rather than explicit encoding. 

$x$ is input, $z$ is latent space, so we encode $p(z)$. Then, decoding is $d(z, theta)$, where $theta$ are decoder weights. We want to maximize $p(x) = integral p_theta(x | z) p(z) d z$ which is the decoding probability. 

#image("../assets/encoder_diagram.png")
#image("../assets/vae_distribution.png")

Assume $p(x | z)$ is Gaussian (for simplicity), then NLL is $-ln p_theta(x | z) = 1/(2 Sigma^2) norm(X - d(z, theta))^2 + C$ which is what we want to maximize. Our goal is $min_theta EE_(z tilde p(z)) [norm(X - d(z, theta))^2]$, and $EE_(p(z))[p_theta(x | z)] = integral p_theta(x | z) p(z) d z$. But we don't know how to sample $p(z)$, so we assume a distribution $q(z)$ to approximate value. 

$p(x) &= EE_(z tilde p)[p(x | z)] \\
&= sum_(z tilde p) p(x | z) p(z) \\
&= sum_(z tilde q) p(x | z) (p(z))/(q(z)) q(z) \\
&= EE_(z tilde q)[p(x | z) ((p(z))/q(z))]
$

Then NLL is: $- ln p(x) lt.eq - EE_(q(z))[ln p(x | z)) + ln (p(z))/(q(z))]$, by Jensen's inequality (If f is convex, $E f(x) gt.eq f(E x)$. Then we simplify to $- ln p(x) lt.eq K L (q(z) || p(z)) - EE_(q(z))[ln p(x | z)]$, where $K L(q(z)||p(z)) = -EE_(z tilde q)[q(z) ln ((p(z))/(q(z)))]$.

We will then choose $p(z) tilde cal(N)(0, I))$ and want to $min_q K L (q(z))||cal(N)(0, I))$. Our encoder will be designed to have outputs $mu, sigma$ which aren't actual means, or standard deviations, but are just parameters for the distribution.

These gaussians result in $K L (cal(N)(mu, sigma))||cal(N)(0, I)) = 1/2(sigma^2 + mu^2 - ln(sigma^2) - 1)$

The other part of objective, $EE_q [ln p(x | z)]$ can be written as $EE_q [ln p(x | accent(x, hat))]$ where $x = d(z, theta)$ and $z = mu(x, theta) + epsilon dot.circle sigma(x, theta)$. This is a reparameterszation trick done so we can backpropagate on $x, theta$, by making the $epsilon$ a separate noise vector. 

Complete procedure:
+ Encode $x$ by computing $mu(x, theta)$ and $sigma(x, theta)$
+ Sample $z = mu + epsilon sigma, epsilon tilde cal(N)(0, I)$
+ Calc KL loss ($1/2 (sigma^2 + mu^2 - ln sigma^2 - 1))$
+ Decode $accent(x, hat)$ using decoder network
+ Calc reconstruction loss, $L(x, accent(x, hat))$ as $1/2 norm(accent(x, hat) - x)^2$ for gaussian or $sum_x x ln accent(x, hat)$ for bernoulli $p(x | accent(x, hat))$
+ Do gradient descent on $theta$ on our error function. Note that we add $beta$ parameter to KL divergence, to adjust its importance.