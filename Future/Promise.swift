//
//  Promise.swift
//  Future
//
//  Created by Arik Devens on 6/6/14.
//  Copyright (c) 2014 danieltiger. All rights reserved.
//

import Foundation

class Promise<T> {
	var future: Future<T>?

	init() {
		future = Future<T>()
	}

	func complete(result: T) {
		if let f = future {
			f.resolvedValue.append(result)
			f.succeeded = true
		}
	}
}