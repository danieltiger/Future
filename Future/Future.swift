//
//  Future.swift
//  Future
//
//  Created by Arik Devens on 6/4/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Future<T> {
	var resolvedValue = T[]()
	var completionHandler: ((T?, NSError?)->())?
	var successHandler: (T?->())?

	init(closure: ()->T?) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			if let value = closure() {
				self.resolvedValue = [value]
			}

			if self.resolvedValue.isEmpty {
				if let handler = self.completionHandler {
					handler(nil, NSError.errorWithDomain("Failed.", code: 100, userInfo: nil))
				}
			} else {
				if let handler = self.successHandler {
					handler(self.resolvedValue[0])
				}

				if let handler = self.completionHandler {
					handler(self.resolvedValue[0], nil)
				}
			}
		}
	}

	func onComplete(handler: (T?, NSError?)->()) {
		completionHandler = handler;
	}

	func onSuccess(handler: T?->()) {
		successHandler = handler
	}
}
