= Gradient Descent
Our goal is to minimize $E(theta)$ (expected Error), so we define gradient $gradient_theta E = mat((partial E)/(partial theta_1), dots, (partial E)/(partial theta_n))$

Error gradient: $tau (d theta)/(d t) = gradient E(theta)$, $t$ is a parameter for "time" as we move through parameter space. 
Euler step: $theta_(n+1) = theta_n + k gradient E(theta_n)$