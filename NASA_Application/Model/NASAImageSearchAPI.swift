//
//  NASAImageSearchAPI.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import RxSwift

import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.URLRequest
import struct Foundation.NSRange
import class Foundation.HTTPURLResponse
import class Foundation.URLSession
import class Foundation.NSRegularExpression
import class Foundation.JSONSerialization
import class Foundation.NSString

/**
 Parsed Nasa images search API response.
 */

enum NASAServiceError: Error {
    case offline
    case NASALimitReached
    case networkError
}

typealias SearchRepositoriesResponse = Result<(searchData: [searchData], nextURL: URL?), NASAServiceError>

class NASAImagesSearchAPI {
    
    // *****************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised               !!!
    // !!! This is just a simple way to move services to one location so you can see Rx code !!!
    // *****************************************************************************************
    static let sharedAPI = NASAImagesSearchAPI(reachabilityService: try! DefaultReachabilityService())
    
    fileprivate let _reachabilityService: ReachabilityService
    
    private init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
}

extension NASAImagesSearchAPI {
    public func loadSearchData(_ searchURL: URL) -> Observable<SearchRepositoriesResponse> {
        return URLSession.shared
            .rx.response(request: URLRequest(url: searchURL))
            .retry(3)
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .map { pair -> SearchRepositoriesResponse in
                if pair.0.statusCode == 403 {
                    return .failure(.NASALimitReached)
                }
                
                let jsonRoot = try NASAImagesSearchAPI.parseJSON(pair.0, data: pair.1)
                
                guard let json = jsonRoot as? [String: AnyObject] else {
                    throw exampleError("Casting to dictionary failed")
                }
                
                let data = SearchData.parse(json)
                
                let nextURL = try NASAImagesSearchAPI.parseNextURL(pair.0)
                
                return .success((repositories: ))
                
        }
    }
}
