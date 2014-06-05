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
		var exp = expectationWithDescription("onComplete with success worked")
		var exp2 = expectationWithDescription("onComplete with failure worked")

		var test: Future<String> = Future {
			return "world"
		}

		test.onComplete { (result, error) in
			if result == "world" {
				exp.fulfill()
			}
		}

		var test2: Future<String> = Future {
			return nil
		}

		test2.onComplete { (result, error) in
			if result == nil && error != nil {
				exp2.fulfill()
			}
		}

		waitForExpectationsWithTimeout(5, handler: nil)
	}

	func testOnSuccess() {
		var exp = expectationWithDescription("onSuccess worked")

		var test: Future<String> = Future {
			return "world"
		}

		test.onSuccess { result in
			exp.fulfill()
		}

		waitForExpectationsWithTimeout(5, handler: nil)
	}

}
