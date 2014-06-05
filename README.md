Future
======

An in-progress implementation of Scala-style Futures in Swift

````
var thing: Future<String> = Future {
  sleep(42)
  return "world"
}

thing.onSuccess { result in
  println("Hello, \(result)")
}

// "Hello, world"
````
