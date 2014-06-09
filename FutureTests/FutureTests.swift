//
//  FutureTests.swift
//  FutureTests
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import XCTest

class FutureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testOnCompleteSuccess() {
		var exp = expectationWithDescription("onComplete success")

		var f: Future<String> = Future {
			return "world"
		}

		f.onComplete { result in
			if result == "world" {
				exp.fulfill()
			}
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testOnCompleteFailure() {
		var exp = expectationWithDescription("onComplete failure")

		var f: Future<String> = Future {
			return nil
		}

		f.onComplete { result in
			if result == nil {
				exp.fulfill()
			}
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testOnSuccess() {
		var exp = expectationWithDescription("onSuccess")

		var test: Future<String> = Future {
			return "Hello"
		}

		test.onSuccess { result in
			if result == "Hello" {
				exp.fulfill()
			}
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testOnFailure() {
		var exp = expectationWithDescription("onFailure")

		var test: Future<String> = Future {
			return nil
		}

		test.onFailure {
			exp.fulfill()
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testMap() {
		var exp = expectationWithDescription("map")

		var test: Future<String> = Future {
			return "Hello, "
		}

		var test2: Future<String> = test.map { result in
			return result + "world"
		}

		test2.onComplete { result in
			if result == "Hello, world" {
				exp.fulfill()
			}
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testPromises() {
		var exp = expectationWithDescription("promises")

		var p = Promise<String>()
		var f = p.future

		Future<String>() {
			var test = "world!"
			p.complete(test)

			return test
		}

		Future<String>() {
			var test = "Hello, "

			f.onSuccess { result in
				var finalResult = test + result

				if finalResult == "Hello, world!" {
					exp.fulfill()
				}
			}

			return test
		}

		waitForExpectationsWithTimeout(4, handler: nil)
	}
}
