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

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

class HomeController: UIViewController, UITableViewDelegate {
    static let startLoadingOffset: CGFloat = 20.0
    
    private var tableView: UITableView!
    
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    private var images = Array<UIImage>()
    private var searchData = SearchData()
    private var oldQuery = ""
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableView()
        loadTitleLabel()
        loadMenuBar()
        loadNavBarButtons()
        loadSearchBar()
    }
    
    private func makeRequest(query: String) {
        
        let urlString = "https://images-api.nasa.gov/search?q=" + query + "&media_type=image"
        
        guard let url = URL(string: urlString) else {
            fatalError("die")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = try? Data(contentsOf: url) else {
                fatalError("no data")
                
            }
            //Implement JSON decoding and paring
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                self.searchData = try JSONDecoder().decode(SearchData.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    for item in self.searchData.collection.items![...4] {
                        guard let imgUrl = URL(string: item.links![0].href!) else {
                            fatalError("no img URL")
                        }
                        
                        guard let imgData = try? Data(contentsOf: imgUrl) else {
                            fatalError("No img data")
                        }
                        
                        guard let image = UIImage(data: imgData) else {
                            fatalError("no img")
                        }
                        
                        self.images.append(image)
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchController.searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(0.6)
            .debug()
            .drive(onNext: { query in
                print("Made Request")
                self.makeRequest(query: query)
                print(self.images)
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func loadTableView() {
        tableView.backgroundColor = UIColor.white
        tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
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
    
    private func loadNavBarButtons() {
        let infoButton = UIBarButtonItem(image: UIImage(named: "information")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleInfo))
        let moreButton = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.rightBarButtonItem = infoButton
        navigationItem.leftBarButtonItem = moreButton
    }
    
    private func loadSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true;
    }
    
    @objc func handleMore() {
        print("top left button")
        //navigationController?.pushViewController(SettingsController, animated: true)
    }
    
    @objc func handleInfo() {
        print("top right button")
        //navigationController?.pushViewController(InfoController, animated: true)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.images.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? ImageCell else {
//            fatalError("Cant get cell")
//        }
//
//        cell.configure(with: CoreImageCellViewModel(image: self.images[indexPath.row]))
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let height = (view.frame.width - 16 - 16) * 9/16
//        return CGSize(width: view.frame.width, height: height + 16 + 16)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
}
