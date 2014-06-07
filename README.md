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

var thing2: Future<String> = Future {
	sleep(42)
	return nil
}

thing2.onComplete { (result, success) in
	switch success {
	case true:
		println("Hello, \(result)")
	case false:
		println("Failed.")
	}
}

// "Failed."

var thing3: Future<String> = Future {
	sleep(42)
	return nil
}

thing3.onFailure { error in
	println(error.localizedDescription)
}

// "Failed."
````
