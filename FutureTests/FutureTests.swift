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

	func testOnSuccess() {
		var exp = expectationWithDescription("Future worked")

		var test: Future<String> = Future {
			return "world"
		}

		test.onSuccess { result in
			exp.fulfill()
		}

		waitForExpectationsWithTimeout(5, nil)
	}

}
