//
//  SearchRequest.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/1/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import Foundation

class SearchRequest: APIRequest {
    var method = RequestType.GET
    var path = "search?q="
    var parameters = [String: String]()
    
    init(name: String) {
        parameters["name"] = name
    }
}
