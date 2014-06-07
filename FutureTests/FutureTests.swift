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

	func testOnComplete() {
		var exp = expectationWithDescription("onComplete success")
		var exp2 = expectationWithDescription("onComplete failure")

		var test: Future<String> = Future {
			sleep(1)
			return "world"
		}

		test.onComplete { (result, success) in
			if result == "world" && success == true {
				exp.fulfill()
			}
		}

		var test2: Future<String> = Future {
			sleep(1)
			return nil
		}

		test2.onComplete { (result, success) in
			if success == false {
				exp2.fulfill()
			}
		}

		waitForExpectationsWithTimeout(2, handler: nil)
	}

	func testMap() {
		var exp = expectationWithDescription("map")

		var test: Future<String> = Future {
			sleep(1)
			return "Hello, "
		}

		var test2: Future<String> = test.map { v in
			sleep(1)
			return v + "world"
		}

		test2.onComplete { (v, s) in
			if v == "Hello, world" {
				exp.fulfill()
			}
		}

		waitForExpectationsWithTimeout(3, handler: nil)
	}
}
