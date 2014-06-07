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
	var isComplete: Bool = false {
	didSet {
		for handler in completionHandlers {
			handler(resolvedValue.isEmpty ? nil : resolvedValue[0])
		}

		if (resolvedValue.isEmpty == false) {
			for handler in successHandlers {
				handler(resolvedValue[0])
			}
		} else {
			for handler in failureHandlers {
				handler()
			}
		}
	}
	}
	var completionHandlers: (T? -> ())[] = []
	var successHandlers: (T? -> ())[] = []
	var failureHandlers: (() -> ())[] = []

	init() { }
	init(futureWork: () -> T?) {
		performFutureWork(futureWork)
	}

	func performFutureWork(futureWork: () -> T?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			self.completeFuture(futureWork())
		}
	}

	func completeFuture(result: T?) {
		if result {
			resolvedValue.append(result!)
		}

		isComplete = true
	}

	func onComplete(handler: T? -> ()) {
		completionHandlers.append(handler)
	}

	func onSuccess(handler: T? -> ()) {
		successHandlers.append(handler)
	}

	func onFailure(handler: () -> ()) {
		failureHandlers.append(handler)
	}

	func map<U>(handler: T -> U) -> Future<U> {
		var future = Future<U>()

		onComplete { result in
			if result {
				future.performFutureWork { handler(result!) }
			} else {
				future.completeFuture(nil)
			}
		}

		return future
	}
}
