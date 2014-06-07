//
//  Future.swift
//  Future
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

struct Future<T> {
	var resolvedValue: T? {
	didSet {
		if let handlers = completionHandlers {
			for handler in handlers {
				handler(resolvedValue, resolvedValue ? true : false)
			}
		}
	}
	}

	var completionHandlers:Array<(T?, Bool)->()>?

	init() {}

	init(body: ()->T?) {
		apply(body)
	}

	mutating func apply(body: ()->T?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let value = body() {
				self.resolvedValue = value
			}
		}
	}

	func onComplete(handler: (T?, Bool)->()) {
		if var handlers = completionHandlers {
			handlers.append(handler)
		}
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
