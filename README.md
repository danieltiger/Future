Future
======

An implementation of Futures and Promises in Swift. Currently only some things are supported, but it's moving pretty quickly.

Creating a future is as simple as passing in a closure with the work you want to do asynchronously. 

````
var testFuture: Future<String> = Future {
  return someLongRunningTask()
}
````

You can set onSuccess, onComplete, and onFailure callbacks for the Future. You can have as many of each of these as you want, they are not guaranteed to be run in any particular order however. Right now errors are reported simply as nil.

````
testFuture.onSuccess { result in
  println("Hello, \(result)")
}

testFuture.onFailure {
  println("Failed.")
}

testFuture.onComplete { result in
  if result {
    println("Hello, \(result)")
  } else {
    println("Failed.")
  }
}
````

In addition I'm trying to support as many combinators as I can. So far I've implemented map, which takes the result of one future and passes it into the computation of a second. It returns the second future and then you can add callbacks on the result of the combined work. You are guaranteed that the second Future won't be run until the first one has completed successfully. If the first Future fails the second Future will not be run, and the failure will be propogated forward.
````
var testMappedFuture = testFuture.map { result in
  return someOtherTask(result)
}
````

I've also added support for Promises. When you complete a Promise you also complete the future it contains. This let's you pass the result of one Future to another in-process Future.

````
var p = Promise<String>()
var f = p.future

var future1 = Future<String> {
	var result = someLongRunningThing()
	
	p.complete(result)
	
	return someOtherLongRunningThing()
}

var future2 = Future<String> {
	var value = doSomethingElseThatTakesTime()
	
	f.onSuccess { result in
		doSomethingWithResult(result)
	}
	
	return value
}
````
