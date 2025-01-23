= Linear Transformation

== Transformations between abstract vectors
*Linear Transformation*: A linear transformation is a function between two vector spaces over the same field that satisfied *linearity*:
1. $L(accent(x, arrow) + accent(y, arrow)) = L(accent(x, arrow)) + L(accent(y, arrow))$
2. $L(t accent(x, arrow)) = t L(accent(x, arrow))$

== Rank and Nullity
*Range*: Given a linear transformation $L: V arrow.r W$ the range of $L$ is the subset of $W$ that can be reached by a linear transformation from a vector in $V$
*Kernel/Nullspace*: The set of vectors in $V$ that map to $0$ in vector space $W$

*Rank*: The dimension of the Range of a linear transformation
*Nullity*: The dimension of the Kernel of a linear transformation

*Rank-Nullity-Theorem*: Let $V$ and $W$ be vector spaces over $F$ with $dim(V) = n$ then $L: V arrow.r W$ is a linear map. Then $"rank"(L) + "nullity"(L) = n$

- Proof: We can focus just on the basis vectors, as everything is based around them. Either $L(accent(x, arrow))$ maps to 0 or not, by definition. Then, the ones that go to $0$ contribute to nullity and the ones that don't contribute to the image. Where they must be unique, because if not, we could create a linear combination of them that lead to them equalling 0, by taking their difference, which puts those vectors in the null space, which goes against our construction.

*Universality of Linear Maps as Matrices*: Note that we can represent every linear map as a matrix by taking the coordinates of the range of the linear map to the basis in the domain. 
- Given $L: V arrow.r W$ then let $[L(accent(v, arrow))]_c = A[accent(v, arrow)]_B$ where $B, C$ are bases of $V, W$ respectively.

*Linear map between bases*: Given bases $B, C$ we can define a change of basis matrix as $()_c[L]_B = [[L(accent(b_1, arrow))]_C dots [L(accent(b_n, arrow))]_C]$

*Matrix of linear map*: Take a linear map between bases, but let the bases be the same before and after.

*Decomposition of linear map*: $()_D[M circle L]_B = ()_D[M]_C ()_C[L]_B$

*Column Space*: Span of columns of a matrix
- Note rank of the matrix is equal to the dimension of the column space of the matrix

*Nullspace*: Set of vectors that the matrix $A$ multiply by to get the zero vector.
- Note nullity is equal to the dimension of the nullspace of the matrix.

== Change of coordinates