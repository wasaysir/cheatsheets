= Hierarchical Models

To model complex objects we can decompose a model into a nested tree of primitives, a directed acyclic graph to precisely describe the recursive and composable nature of the hierarchy.

To implement this simply, since our hierarchy's render objects via aDFS traversal of DAG, we maintain a matrix stack of previous transformations to allow composition of matrices without having to directly keep track of how these all interact together. Each time we move down in the hierarchy we "push" a new transformation and "pop" when we're done. MultMatrix multiplies given matrix $M$ with top element of stack and replaces top of stack with result.

#image("../assets/hierarchical-dag.png")
