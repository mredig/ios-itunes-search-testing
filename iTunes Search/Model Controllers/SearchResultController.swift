//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Spencer Curtis on 8/5/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

enum SearchError: Error, Equatable {
	case invalidJSON
}

class SearchResultController {

	var dataLoader: NetworkDataLoader

	init(dataLoader: NetworkDataLoader = URLSession.shared) {
		self.dataLoader = dataLoader
	}
    
	func performSearch(for searchTerm: String, resultType: ResultType, completion: @escaping ([SearchResult], Error?) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let parameters = ["term": searchTerm,
                          "entity": resultType.rawValue]
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
		dataLoader.loadData(with: request) { (data, error) in

            if let error = error {
				NSLog("Error fetching data: \(error)")
				completion([], error)
				return
			}
            guard let data = data else { completion([], NSError()); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = searchResults.results
				completion(self.searchResults, nil)
            } catch {
                print("Unable to decode data into object of type [SearchResult]: \(error)")
				completion([], SearchError.invalidJSON)
            }
        }
    }
    
    let baseURL = URL(string: "https://itunes.apple.com/search")!
    var searchResults: [SearchResult] = []
}
