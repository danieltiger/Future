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

	func map<U>(f: T -> U) -> Future<U> {
		var p = Promise<U>()

		onComplete { (result, success) in
			if let v = result {
				p.complete(f(v))
			}
		}

		return p.future
	}
}
