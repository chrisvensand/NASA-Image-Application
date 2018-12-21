//
//  APIClient.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/1/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit
import Foundation

final class APIClient {
    private let baseURL: String = "https://images-api.nasa.gov/"
    
    private func fetchData(query: String, completion: (() -> Void)? = nil) {
        let urlString = baseURL + query
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("error \(error.localizedDescription)")
                } else {
                    print("Unknown error")
                }
                self.showErrorAlert(query: query)
                completion?()
                return
            }
            
            guard let data = try? JSONDecoder().decode(SearchData.self, from: data) else {
                print("unable to decode data")
                self.showErrorAlert(query: query)
                completion?()
                return
            }
            
            self?.sites = siteData.sites.sorted { $0.name < $1.name }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                completion?()
            }
        }.resume()
        
        
            
    }
    
    private func showErrorAlert(query: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Error fetching data", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Retry", style: .default, handler: { _ in
                self.fetchData(query: query)
            })
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }
    }
        
}
    

