= Auto-Differentiation
Each operation is a square with its variable dependencies. Each variable has a pointer to creator(operation that created it)

Pseudocode: Function $f = g(x, y, dots)$: 1) Create $g$ Op object. 2) Save references to args $x, y, dots$. 3) Create Var for output $f$. 4) Set $"g.val"$ as $g(x, y, dots)$. 5) Set $"f.creator"$ to the $g$ Op.

== Differentiate
With each object in our graph, store derivative of total expression with respect to itself in member _grad_
Use chain rule with parent operation Op.grad to get current grad. Ex: If y is parent of x, then x.grad = y.grad $dot (partial y)/(partial x)$ Add when multiple branches converge.

Backward method:
```
Var.backwards: self.grad += s; self.creator.backward(s)

Op.backward(s): for x in self.args: 
x.backward(s * partialDeriv(Op, x))
```

In Var, self.val, self.grad, s must have same shape. 
In Op, s must be shape of operation output