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
	var successHandler: (T->())?

	init(closure: ()->T) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			self.resolvedValue = [closure()]
			if let handler = self.successHandler {
				handler(self.resolvedValue[0])
			}
		}
	}

	func onSuccess(handler: T->()) {
		successHandler = handler
	}
}
