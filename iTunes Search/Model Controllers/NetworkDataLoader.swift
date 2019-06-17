//
//  NetworkDataLoader.swift
//  iTunes Search
//
//  Created by Michael Redig on 6/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
	func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkDataLoader {
	func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
		let task = self.dataTask(with: request) { (data, _, error) in
			completion(data, error)
		}
		task.resume()
	}
}
