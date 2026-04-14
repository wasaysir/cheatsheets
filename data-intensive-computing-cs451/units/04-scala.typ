= Scala
- Language build on top of JVM
- Function and OOP
- Every value is an object, every function is a value

println: prints

Variables:
`var mi: Int = 3` declares a mutable integer, that's allowed reassignment \
`val ci: Int = 5` declares a constant integer

`var, val` refers to mutable and immutable references, respectively. A `var` reference to an immutable object changes the reference to a new object when reassignment. Similarly, `val` can reference mutable objects

Spark automatically does type inference if possible, but it doesn't allow dynamic typing.

=== Collections:
Array is declared as `var myArray = Array(1, 2.0, 3)` \
Array type is automatically derived. You can have an array of mixed types, either by:
- Converting some of the values into the same type (e.g. myArray casts to Double)
- Finding common superclass
- Allowing unions (e.g. Array[Double union Int])
- Letting it be type Any

==== Array
Array access: `myArray(5)` selects 5th index of Array
Array append: `myArr :+ e` appends element `e` to end of `myArr`
Array prepend: `e +: myArr` places element `e` at front of `myArr`
Note arrays are immutable, so this is a copy-and-write with a shallow copy, so object references are copied over. \
`varArr ++= valArr` is an inplace concatenation of `valArr` to `varArr` \
`valArr ++= varArr` is impossible, since `valArr` is immutable \
`++=` will call it if defined for the specific Array type, otherwise, it copies `varArr` to a new array and concatenates the second aray. Then it reassigns the reference of the first array to the new array. \

==== Map
- Two forms of Map, immutable and mutable
- Maps are unordered, and sorted in hash order.
- `Map("a"->3, "b"->4)` is one way to define
- `scala.collection.mutable.Map("a"->3, "b"->4)` is full reference path
- `val valMap = scala.collection.mutable.Map("a"->3)` allows the map to be mutable, but the val is a const pointer to the map. 
  - `+=` to a `valMap` creates a new node in the trie, without changing the reference itself
- Immutable data structures are MUCH faster in RDDs, because appending to mutable data structures are copy-appends
- Immutable data structures are also copy-appends, but they run in constant time
  - This is because the immutable hash map is a trie using the hash code as the "String"
  - It doesn't involve rotations, so producing a new tree based on the old one is $O(h)$ and the tree has a fixed height (32)
- `"a"->3` and `("a", 3)` are syntactically equivalent for maps

==== Loops
- while loops exist, but are irrelevant for us
- for loops with two different Range object types:
  - `for (i <- 1 to 10)` Inclusive [1, 10]
  - `for (i <- 0 until 10)` Excluse [0, 10)
    - `1 to 10` is a Range.inclusive object
- for loops can add conditionals
  - `for (i <- 0 until 10 if i % 2 == 1)`
  - `for (i <- 0 to 10 by 1)`
- Sequence objects are made as:
  - `for (i <- 1 to 10) yield i`, which is similar to Python generators, but they're fully calculated

==== Functions
- `def func(param: Type): returnType = {body}`
  - Note return type is optional if type can be easily derived
  - parameter types are mandatory
  - In function body, last line should be the returned value
  - Don't use keyword `return` unless you want to return in multiple places, otherwise Scala will throw compile errors
- You can call functions like `F(x, y)`, but if function has no parameters `F()`, you can call function with `F`
  - Using `F _` allows you to pass function as a value, without calling it
- Anonymous functions
  - e.g. `(x: Int) => x * x`
    - Parameter types are mandatory unless passing directly to higher-order function
  - Implicit parameter:
    - Expression with underscores
    - e.g. (`_ + _`) equivalent to `def func(x, y) = {x + y}`

*Tuple Unpacking*: `(k, v) <- pair`
Unit: Scala equivalent for Void to denote a lack of a value. 

==== Pattern Matching
Equivalent to `case`, but allows for pattern matching within the case itself.

`def f(x: Any) : String = x match {
  case List(y) => f(y)
  case y: String => y
  case _ => "?"
}
`

==== Option
Collection holding up to 1 A type value—either None or Some[A]. To get A val, from a Some, use get. 
`def maybeAdd1(x: Option[Int]): Option[Int] = x match {
  case Some(y) => Some(y+1)
  case None => None
}
` or `case None => None
case _ => Some(x.get + 1)`

==== Map Data Struct
`Map[K, V].get(k)` returns `Option[V]`
`Map[K, V](k)` returns V or throws key not found exception

==== Interoperability with Java
Scala can interact with Java objects, but not Java collections. So you must convert.
`import scala.collection.JavaConverts._` and then `javaArrayBuffer.asScala`