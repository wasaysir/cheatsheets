= Vector Spaces

Definition: A set $V$ over field $F$ with addition and multiplication operations such that addition is closed, and multiplication is closed (any scalar from Field F multiplied by vector from $V$ results in another vector in $V$)

== Vector space axioms
1. Additive associativity ($(accent(x, arrow) + accent(y, arrow)) + accent(z, arrow) = accent(x, arrow) + (accent(y, arrow) + accent(z, arrow))$)
2. There is a zero vector such that adding to it returns the same vector. ($accent(x, arrow) + accent(0, arrow) = arrow(x)$)
3. Additive inverse exists ($accent(x, arrow) + accent(-x, arrow) = accent(0, arrow)$)
4. Additive Commutativity ($accent(x, arrow) + accent(y, arrow) = accent(y, arrow) + accent(x, arrow)$)
5. Multiplicative Associativity ($s dot (t dot (accent(x, arrow))) = (s t) dot accent(x, arrow)$)
6. Scalar Distributivity ($(s + t) dot accent(x, arrow) = s dot accent(x, arrow) + t dot accent(x, arrow)$)
7. Vector Distributivity ($s dot (accent(x, arrow) + accent(y, arrow)) = s dot accent(x, arrow) + s dot accent(y, arrow)$)
8. Multiplicative identity ($1 dot accent(x, arrow) = accent(x, arrow)$)

=== Uniqueness of special vectors
Zero vector must be unique because suppose not, then you'd have $0_1 + 0_2 = 0_1 = 0_2 + 0_1 = 0_2$. QED

Additive inverse is unique. Note if this was not the case, then $x + (-x)_1 = x + (-x)_2$ then we get $-x_1 + x + (-x)_1 = -x_1 + x + (-x)_2 = 0 + (-x)_1 = 0 + (-x)_2$ which implies $(-x)_1 = (-x)_2$

== Subspaces
A subspace is a subset of $V$ that inherits addition and scalar multiplication from $V$ and is also a vector space over $F$.

=== Subspace Test
- Subspace must be non-empty
- Subspace must be closed under addition
- Subspace must be closed under scalar multiplication 

*Linear Combination*: A vector that is the sum of multiplications of vectors in a set.
*Span*: A set of vectors that can be formed as a linear combination of a subset of vectors. 
*Spanning Set*: A subset of vectors in a vector space that spans all of the vector space.
*Linearly independent*: If the only linear combination of a set of vectors that results in $0$ is the trivial combination.
=== Bases
*Basis*: A vector set that is linearly independent and spans $V$

- All bases have the same number of vectors, which is the dimension of the set
- Any spanning set will have at least as many vectors as the dimension of the vector space
- Any linearly independent set will have at most as many vectors as the dimension of the vector space.
- A set with exactly $n$ vectors in $V$ is a spanning set iff it is linearly independent.
PROOF: We can map each vector in linearly independent set to a spanning vector, if there are more in the linearly independent set, then we will cover the entire vector space, including the extra vectors not in the spanning set size, then we can write the additive inverse as a linear combinatino of the spanning vectors which added to the new vector provides a non-trivial solution to 0, making this a linearly dependent set, and a contradiction.

==== Obtaining a Basis
- Either extend a linearly independent set until spanning
- Or reduce a spanning set until linearly independent.

=== Coordinates
You can write vectors as a set of coordinates (the coefficients to the linear combination of the basis).


==== Unique Representation Theorem
Note, every vector can be uniquely written as a linear combination of a basis. (Because it is spanning every vector is written as a linear combination) and because it is linearly independent it must be unique, otherwise there'd be a non-trivial solution to equal 0.

*Ordered Basis*: A basis set with a fixed ordering.
*Coordinate vector with respect to a basis*: This is a vector set that contains the coefficients to the linear combination of a vector based on an ordered basis.