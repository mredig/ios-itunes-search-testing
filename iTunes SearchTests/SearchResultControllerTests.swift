//
//  SearchResultControllerTests.swift
//  iTunes SearchTests
//
//  Created by Michael Redig on 6/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
@testable import iTunes_Search

class SearchResultControllerTests: XCTestCase {

	class MockDataLoader: NetworkDataLoader {
		var request: URLRequest?
		var data: Data?
		var error: Error?

		func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
			self.request = request
			completion(data, error)
		}
	}


	func testSearchResults() {
		let controller = SearchResultController()
		let waitForSearchResult = expectation(description: "Wait for results")

		controller.performSearch(for: "Poopmaster", resultType: .software) { _, _ in
			waitForSearchResult.fulfill()
		}

		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				print("Failed waiting for search result: \(error)")
				XCTFail()
			}
		}

		XCTAssertTrue(controller.searchResults.count > 0, "Expecting at least 1 app match")
	}

	func testSearchResultsMocking() {
		let mock = MockDataLoader()
		mock.data = goodResultData

		let controller = SearchResultController(dataLoader: mock)
		let waitForSearchResult = expectation(description: "Wait for results")

		controller.performSearch(for: "Poopmaster", resultType: .software) { _, _ in
			waitForSearchResult.fulfill()
		}

		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				print("Failed waiting for search result: \(error)")
				XCTFail()
			}
		}

		XCTAssertTrue(controller.searchResults.count > 0, "Expecting at least 1 app match")
	}

	func testSearchResultsBadData() {
		let mock = MockDataLoader()
		mock.data = badResultData

		let controller = SearchResultController(dataLoader: mock)
		let waitForSearchResult = expectation(description: "Wait for results")

		controller.performSearch(for: "Poopmaster", resultType: .software) { results, error in
			XCTAssertEqual(error as! SearchError, SearchError.invalidJSON)

			waitForSearchResult.fulfill()
		}

		waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				print("Failed waiting for search result: \(error)")
				XCTFail()
			}
		}
	}
}
