//
//  Future.swift
//  Future
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Future<T> {
	var resolvedValue: Array<T> = []
	var isComplete: Bool = false
	let operationQueue: NSOperationQueue

	init() {
		operationQueue = NSOperationQueue()
		operationQueue.suspended = true
	}

	convenience init(futureWork: () -> T?) {
		self.init()

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
		operationQueue.suspended = false
	}

	func onComplete(handler: T? -> ()) {
		operationQueue.addOperationWithBlock { [unowned self] in
			handler(self.resolvedValue.isEmpty ? nil : self.resolvedValue[0])
		}
	}

	func onSuccess(handler: T -> ()) {
		if isComplete {
			operationQueue.addOperationWithBlock { [unowned self] in
				if self.resolvedValue.isEmpty == false {
					handler(self.resolvedValue[0])
				}
			}
		} else {
			operationQueue.addOperationWithBlock { [unowned self] in
				handler(self.resolvedValue[0])
			}
		}
	}

	func onFailure(handler: () -> ()) {
		operationQueue.addOperationWithBlock { [unowned self] in
			if self.isComplete && self.resolvedValue.isEmpty {
				handler()
			}
		}
	}

	func map<U>(handler: T -> U) -> Future<U> {
		let future = Future<U>()

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
