//
//  Future.swift
//  Future
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Future<T> {
	var resolvedValue: T?[] = []
	var succeeded: Bool = false {
	didSet {
		for handler in completionHandlers {
			handler(resolvedValue.isEmpty ? nil : resolvedValue[0], succeeded)
		}
	}
	}
	var completionHandlers: ((T?, Bool)->())[] = []

	init() {}

	init(body: ()->T?) {
		apply(body)
	}

	func apply(body: ()->T?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let value = body() {
				self.resolvedValue.append(value)
				self.succeeded = true
			} else {
				self.succeeded = false
			}
		}
	}

	func onComplete(handler: (T?, Bool)->()) {
		completionHandlers.append(handler)
	}

	// Not currently possible due to language limitations. Hopefully will be fixed soon.
//	mutating func map<U>(transform: T -> U) -> Future<U> {
//		var future = Future<U>()
//
//		onComplete { (result, success) in
//			self.apply {
//				return transform(result)
//			}
//		}
//
//		return future
//	}
}
