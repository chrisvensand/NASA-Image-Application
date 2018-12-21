//
//  ImageCellViewModel.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit.UIImage

protocol ImageCellViewModel {
    var image: UIImage { get }
}

final class CoreImageCellViewModel: ImageCellViewModel {
    let image:  UIImage
    
    init(with image: UIImage) {
        self.image = image
    }
    
    // MARK: API
    
    public func setImage(imgURL: String) {
        image.image .
    }

}
