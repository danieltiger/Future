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

thing2.onComplete { (result, error) in
	if result {
		println("Hello, \(result)")
	}
	
	if error {
		println(error.localizedDescription)
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
