//
//  ViewController.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 7/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height))
        titleLable.text = "NASA"
        titleLable.textColor = UIColor.black
        titleLable.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLable
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "CellID")
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupNavBarButtons() {
        let searchImage = UIImage(named: "shining")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "shining")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItem = searchBarButtonItem
        navigationItem.leftBarButtonItem = moreButton
    }
    
    @objc func handleMore() {
        
    }
    
    @objc func handleSearch() {
        print(123)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9/16
        return CGSize(width: view.frame.width, height: height + 16 + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
