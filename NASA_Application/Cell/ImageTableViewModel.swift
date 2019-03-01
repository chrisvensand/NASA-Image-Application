//
//  ImageCellViewModel.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 10/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {
    
    lazy var imgView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(imgView)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.translatesAutoresizingMaskIntoConstraints = false
        self.imgView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
                                    imgView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 10.0),
                                    imgView.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: 10.0),
                                    imgView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10.0),
                                    imgView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 10.0),
                                    imgView.widthAnchor.constraint(equalToConstant: 600),
                                    imgView.heightAnchor.constraint(equalToConstant: 400)
                                    ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func setImage(imgURL: String) {
        
        guard let url = URL(string: imgURL) else {
            print("Cannot create URL from: \(imgURL)")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let view = self?.imgView else {
                    return
                }
                guard let image = UIImage(data: data) else {
                    return
                }
                view.image = image
            }
        }
        
    }
    
}
