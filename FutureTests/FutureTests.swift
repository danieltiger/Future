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
		let exp = expectationWithDescription("onComplete success")

		let f: Future<String> = Future {
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
		let exp = expectationWithDescription("onComplete failure")

		let f: Future<String> = Future {
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
		let exp = expectationWithDescription("onSuccess")

		let test: Future<String> = Future {
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
		let exp = expectationWithDescription("onFailure")

		let test: Future<String> = Future {
			return nil
		}

		test.onFailure {
			exp.fulfill()
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}

	func testMap() {
		let exp = expectationWithDescription("map")

		let test: Future<String> = Future {
			return "Hello, "
		}

		let test2: Future<String> = test.map { result in
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
		let exp = expectationWithDescription("promises")

		let p = Promise<String>()
		let f = p.future

		Future<String>() {
			let test = "world!"
			p.complete(test)

			return test
		}

		Future<String>() {
			let test = "Hello, "

			f.onSuccess { result in
				let finalResult = test + result

				if finalResult == "Hello, world!" {
					exp.fulfill()
				}
			}

			return test
		}

		waitForExpectationsWithTimeout(1, handler: nil)
	}
}
