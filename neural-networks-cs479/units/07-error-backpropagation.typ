= Error Backpropagation
$gradient_(z^((l+1))) E = (partial E)/(partial z^((l+1)))$
$h^((l+1)) = sigma(z^((l+1))) = sigma(W^((l))h^((l)) + b^((l+1)))$ Basically, $h$ is hidden layer, $z$ is input current, $W$ is weight matrix, $b$ is bias. 
$gradient_(z^((l))) E = (d h^((l)))/(d z^((l))) dot.circle [gradient_(z^((l+1)) E dot (W^((l))^T))]$ $dot.circle$ is hadamard product, which does element by element multiplication. We transpose because $W_(i j)$ is connection from $i"th"$ node in $l$ to $j"th"$ node in $l+1$ 

Note that $accent(a, arrow) = accent(x, arrow) W$ in this diagram: #figure(
  image("../assets/neuralNet.png", width: 30%),
)

$(partial E)/(partial W_(i j)^((l)) = (partial E)/(partial z_j^((l+1))) dot (partial z_j^((l+1)))/(partial W_(i j)^((l))) = (partial E)/(partial z_j^((l+1))) dot h_i^((l))$

Finally, 
$gradient_(z^((l)))E = sigma'(z^((l))) dot.circle (gradient_(z^((l+1))) E dot (W^((l)))^T)$
$gradient_(W^((l))) E = [h^((l))]^T gradient_(z^((l+1))) E$

== Vectorization
We can generalize this process to take a batch of samples by letting $x$ be a matrix of samples instead of just one sample. Then, note $gradient_(z^((l))) E$ is a matrix with same dimension as $z^((l))$ as desired. Further, note that $gradient_(W^((l))) E$ is a gradient vector that sums the weight gradient matrix from each sample.