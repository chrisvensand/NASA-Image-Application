//
//  ViewController.swift
//  NASA_Application
//
//  Created by Christopher Vensand on 7/21/18.
//  Copyright © 2018 Christopher Vensand. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate {
    private static let startLoadingOffset: CGFloat = 20.0
    fileprivate let cellID = "ImageCell.Reuse"
    private let searchController = UISearchController(searchResultsController: nil)
    private let decoder = JSONDecoder()
    private var imgURLs = [String]()
    private var searchData = SearchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
        //fetchData(query: "Comet")
    }
    
    // MARK: - Helpers
    
    private func fetchData(query: String, completion: (() -> Void)? = nil) {
        let urlString = "https://images-api.nasa.gov/search?q=" + query
        guard let url = URL(string: urlString) else {
            print("Unable to to create URL from: \(urlString)")
            return
        }
        
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
            
            guard let newSearchData = try? JSONDecoder().decode(SearchData.self, from: data) else {
                print("unable to decode data")
                self.showErrorAlert(query: query)
                completion?()
                return
            }
            
            self.searchData = newSearchData
            
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
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(self.handleRefresh), for: UIControl.Event.valueChanged)
        return control
    }()
    
    @objc private func handleRefresh() {
        fetchData(query: "searchController.text") { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    
    // MARK: - Table view setup
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    // MARK: - Title label setup
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height))
        setUpTitleLabel(name: titleLabel)
        return titleLabel
    }()
    
    private func setUpTitleLabel(name titleLabel: UILabel) {
        titleLabel.text = "NASA Images"
        titleLabel.textColor = UIColor.black
        guard let customFont = UIFont(name: "nasalization", size: UIFont.labelFontSize) else {
            fatalError("""
        Failed to load the "nasalization-rg" font.
        Make sure the font file is included in the project and the font name is spelled correctly.
        """
            )
        }
        titleLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    // MARK: - Navigation bar setup
    
    private func setupNavigationBar() {
        
        // Create and add bar buttons
        let infoButton = UIBarButtonItem(image: UIImage(named: "information")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleInfo))
        let moreButton = UIBarButtonItem(image: UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.rightBarButtonItem = infoButton
        navigationItem.leftBarButtonItem = moreButton
        
        
        // Search Controller setup
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // UI settings
        UINavigationBar.appearance().barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleLabel
        
    }
    
    // MARK: - TableView setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.white
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(tableView)
    }
    
    // MARK: - Settings button
    @objc func handleSettings() {
        print("top left button")
        print(searchData)
        //navigationController?.pushViewController(SettingsController, animated: true)
    }
    
    // MARK: - Info button
    @objc func handleInfo() {
        print("top right button")
        print(searchData)
        //navigationController?.pushViewController(InfoController, animated: true)
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}

extension HomeController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setImage(imgURL: imgURLs[indexPath.row])
        cell.backgroundColor = UIColor.white
        return cell
    }
}

extension HomeController: UISearchResultsUpdating {
    // Mark: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

