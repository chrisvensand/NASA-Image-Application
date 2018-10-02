//
//  APIRequest.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/1/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import Foundation

// Universal protocal to handle different requests by the same APIClient
protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    func request(with baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

public enum RequestType: String {
    case GET, POST
}
