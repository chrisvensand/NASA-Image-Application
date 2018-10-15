//
//  ViewController.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 7/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    private var images = BehaviorRelay<[UIImage]>(value: [])
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCollectionView()
        loadTitleLabel()
        loadMenuBar()
        loadNavBarButtons()
        loadSearchBar()
    }
    
    
    private func makeRequest(query: String) {
        guard let url = URL(string: "https://images-assets.nasa.gov/image/PIA07081/PIA07081~thumb.jpg") else {
            fatalError("die")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("no data")
        }
        
        guard let image = UIImage(data: data) else {
            fatalError("no img")
        }
        
        var old = images.value
        old.append(image)
        images.accept(old)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        images.asDriver()
            .drive(onNext: { (imgs) in
                print(imgs.count)
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(0.3)
            .drive(onNext: { query in
                self.makeRequest(query: query)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func loadCollectionView() {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "CellID")
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    private func loadTitleLabel() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height))
        titleLabel.text = "NASA Images"
        titleLabel.textColor = UIColor.black
        guard let customFont = UIFont(name: "NasalizationRg-Regular", size: UIFont.labelFontSize) else {
            fatalError("""
        Failed to load the "NasalizationRg-Regular" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        titleLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel.adjustsFontForContentSizeCategory = true
        navigationItem.titleView = titleLabel
    }
    
    private func loadMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    private func callApi(callback: () -> Void) {
        // do things
        //im done:
        callback()
    }
    
    private func loadNavBarButtons() {
        let searchImage = UIImage(named: "information")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        let moreButton = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = searchBarButtonItem
        navigationItem.leftBarButtonItem = moreButton
    }
    
    private func loadSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func handleMore() {
        print("top left button")
    }
    
    @objc func handleSearch() {
        print("top right button")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.value.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? ImageCell else {
            fatalError("Cant get cell")
        }
        
        cell.thumbnailImageView.image = images.value[indexPath.row]
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
