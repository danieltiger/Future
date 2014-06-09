//
//  Promise.swift
//  Future
//
//  Created by Arik Devens on 6/8/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Promise<T> {
	var future: Future<T> = Future<T>()

	func complete(value: T) {
		if future.resolvedValue.isEmpty {
			future.completeFuture(value)
		}
	}
}