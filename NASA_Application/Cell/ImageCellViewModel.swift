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
    func setImage(imgURL: String) {
        
        DispatchQueue.global(qos: .utility).async {
            self.getSetImg(URL: imgURL, cell: cellImage){ [weak self] (imgURL, cellImage) in
                
            }
        }
        
    }
    
    func getSetImg(URL imgURL: String, cell: UIImage, setImg: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .utility).async {
            
        }
    }
    
}
