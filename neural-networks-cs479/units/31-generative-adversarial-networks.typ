= Generative Adversarial Networks

Two networks: Generative Network and Discriminative Network

$D(x; theta)$ - Probability $x$ is real. $G(z; phi)$ - Create input sample from random noise $z$ drawn from $p_z$ distribution.

Loss function: $E(Theta, phi) = EE_(x tilde cal(R), cal(F))[cal(L)(D(x; theta), t)] + EE_(z tilde p_z)[cal(L)(D(G(z; phi), phi), 1)]$
Term 1: Minimize $theta$ to make discriminator better
Term 2: Minimize $phi$ to make generator better at producing fake inputs.

Train discriminator: $min_theta EE_(cal(R), cal(F))[cal(L)(y, t)]$ $R$ are real inputs, $F$ are fake. 
Update rule: $theta arrow.l theta - kappa gradient_theta cal(L)(y, t)$
Train generator: $min_theta EE_(cal(F))[cal(L)(y, 1)]$
Update rule: $phi arrow.l phi - kappa gradient_phi cal(L)(y, 1)$ (We use 1 to simulate a targeted adversarial attack with target 1) Gradients propagate through $D$ down to $G$. Note that $y$ is the discriminator being run on generated outputs.