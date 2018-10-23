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
    private var collectionView: UICollectionView!
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchData = SearchData()
    private var images = Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTableView()
        loadTitleLabel()
        loadMenuBar()
        loadNavBarButtons()
        loadSearchBar()

        let bag = DisposeBag()
        
        let searchResults = searchController.searchBar.rx.text.orEmpty
        
        searchResults.debounce(1, scheduler: MainScheduler.instance)
        
        searchResults.subscribeOn(MainScheduler.instance)
        
        searchResults.subscribe(onNext:{
            
            let urlString = "https://images-api.nasa.gov/search?q=" + $0 + "&media_type=image"

            print(urlString)

            guard let url = URL(string: urlString) else {
                fatalError("URL")
            }
            
            // Retrieve URL data
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }

                guard let data = try? Data(contentsOf: url) else {
                    fatalError("No Data")
                }

                do {
                    self.searchData = try JSONDecoder().decode(SearchData.self, from: data)
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
            
            // Get images from URL data
            for item in self.searchData.collection.items! {
                DispatchQueue.main.async {
                    guard let imgUrl = URL(string: item.links![0].href!) else {
                        fatalError("no img URL")
                    }

                    guard let imgData = try? Data(contentsOf: imgUrl) else {
                        fatalError("No img data")
                    }

                    guard let image = UIImage(data: imgData) else {
                        fatalError("no img")
                    }
                    
                    //Create UITableViewCell
                    let cell = ImageCell()
                    
                    cell.configure(with: CoreImageCellViewModel(with: image))
                    
                    self.tableView.beginUpdates()
                    
                    let indexPath: IndexPath = IndexPath(row: (self.images.count - 1), section: 0)
                    
                    self.tableView.insertRows(at: [indexPath], with: .left)
                    
                    self.tableView.endUpdates()
                }
            }
        })
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func loadTableView() {
        tableView?.backgroundColor = UIColor.white
        tableView?.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
        tableView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
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
        print(searchData)
        //navigationController?.pushViewController(SettingsController, animated: true)
    }
    
    @objc func handleInfo() {
        print("top right button")
        //navigationController?.pushViewController(InfoController, animated: true)
    }
    
}
