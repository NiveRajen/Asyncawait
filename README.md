# Asyncawait


Await is the keyword to be used for calling async methods. You can see them as best friends in Swift as one will never go without the other.

Structured concurrency with async-await method calls makes it easier to reason about the execution order. Methods are linearly executed without going back and forth as you would with closures.

Advantages:

1. You have to call the completion closure in each possible method exit. Not doing so will possibly result in an app endlessly waiting for a result.
2. Closures are more complicated to read. Reasoning about the order of execution is not as easy as it is with structured concurrency.
3. Retain cycles need to be avoided using weak references.
4. Implementors need to switch over the result to get the outcome. Try-catch statements cannot be used at the implementation level.


