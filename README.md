# Asyncawait


Await is the keyword to be used for calling async methods. You can see them as best friends in Swift as one will never go without the other.

Structured concurrency with async-await method calls makes it easier to reason about the execution order. Methods are linearly executed without going back and forth as you would with closures.

Advantages:

1. You have to call the completion closure in each possible method exit. Not doing so will possibly result in an app endlessly waiting for a result.
2. Closures are more complicated to read. Reasoning about the order of execution is not as easy as it is with structured concurrency.
3. Retain cycles need to be avoided using weak references.
4. Implementors need to switch over the result to get the outcome. Try-catch statements cannot be used at the implementation level.

Performance Considerations
Context Switching: Asynchronous tasks may involve context switching, especially if they yield control back to the system (e.g., during I/O operations). This can introduce overhead as the system saves and restores state.
Task Creation Overhead: Creating a new Task incurs some overhead. While Task is lightweight, frequent task creation in tight loops can lead to performance degradation. Consider reusing tasks or minimizing the frequency of task creation where possible.
Memory Usage: Each task can use memory for its context, including stack space and local variables. If you have a large number of concurrently running tasks, this can lead to increased memory usage. Monitor your application's memory consumption, especially in scenarios with many concurrent tasks.
Blocking the Main Thread: Although async/await improves responsiveness by offloading work, you must ensure that the main thread is not blocked by awaiting tasks that perform heavy computation. Always ensure computationally intensive tasks run on background threads.

Best Practices

1. Limit Task Creation: Avoid creating tasks in tight loops. Instead, consider batching work or using async let to start multiple tasks concurrently within a single context.
2. Use Task Groups: For dynamic task creation where you don't know the number of tasks in advance, use TaskGroup. This approach provides better resource management and makes it easier to handle results and errors
3. Check for Cancellation: Ensure that long-running tasks periodically check for cancellation using Task.isCancelled. This helps prevent unnecessary work if the task is no longer needed.
4. Optimize I/O Operations: When performing network requests or file I/O, use asynchronous APIs that return promises or futures. This allows you to take advantage of the non-blocking nature of async/await without blocking threads.
5. Profile and Measure Performance: Use Instruments and other profiling tools to measure the performance impact of your asynchronous code. Look for bottlenecks and areas where the task overhead is significant.
6.Avoid Long Chains of Await: Minimize the number of sequential awaits. Instead, try to run independent tasks concurrently whenever possible. This will improve throughput.



@escaping
Definition:
A closure marked with @escaping indicates that the closure can outlive the scope of the function in which it is defined. This is commonly used when a closure is stored for later execution, such as when passed to asynchronous functions or stored in properties.

Usage:

Asynchronous Operations: When a closure is executed after a function returns, it must be marked as @escaping. This is typical in completion handlers for network requests or background tasks.
Storing Closures: If you store a closure in a variable or property to be executed later, it needs to be marked as @escaping.


@autoclosure
Definition:
An @autoclosure is a special attribute that allows you to pass an expression that gets wrapped in a closure automatically. It is often used for simplifying syntax when you want to delay the evaluation of an expression.

Usage:

Lazy Evaluation: Useful when you want to defer the evaluation of an expression until it is needed, often in APIs that require closures.
Default Parameters: You can use @autoclosure in function parameters to allow passing simple expressions that get evaluated only when called.
