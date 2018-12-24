//
//  ImageCellViewModel.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    
    var cellImage: UIImage? = UIImage(named: "defaultImage")
    
    // MARK: - Helpers
    
    func setImage(imgURL: String) {
        
        guard let url = URL(string: imgURL) else {
            print("Cannot create URL from: \(imgURL)")
            return
        }
        
        let request = URLRequest(url: url)
        
        fetchImage(request)
        
    }
    
    private func fetchImage(_ request: URLRequest) {
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print("error \(error.localizedDescription)")
                } else {
                    print("Unknown error")
                }
                return
            }
            
            guard let cellImage = UIImage(data: data) else {
                print("Unable to create UIImage")
                return
            }
            
            DispatchQueue.main.async {
                self.cellImage = cellImage
            }
        }.resume()
    }
    
}
