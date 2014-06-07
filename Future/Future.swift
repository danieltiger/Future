//
//  Future.swift
//  Future
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Future<T> {
	var resolvedValue: T[] = []
	var succeeded: Bool = false {
	didSet {
		for handler in completionHandlers {
			handler(resolvedValue.isEmpty ? nil : resolvedValue[0])
		}
	}
	}
	var completionHandlers: ((T?)->())[] = []

	init() { }
	init(futureWork: ()->T?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			Promise<T>(future: self).complete(futureWork())
		}
	}

	func onComplete(handler: (T?)->()) {
		completionHandlers.append(handler)
	}

	func map<U>(handler: T -> U) -> Future<U> {
		var promise = Promise<U>()

		onComplete { result in
			var mappedWork: U? = nil

			if result {
				mappedWork = handler(result!)
			}

			promise.complete(mappedWork)
		}

		return promise.future
	}
}
