//
//  FeedController.swift
//  FeedReader
//
//  Created by Ron Daryl Magno on 2/5/18.
//  Copyright © 2018 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Kingfisher

protocol IFeedView: class {
    func setProducts(products: [Product])
    func appendProducts(products: [Product])
    func reloadData()
}

class FeedViewController: UIViewController, IFeedView {
    // MARK: - Data
    var products: [Product] = []
    let disposeBag = DisposeBag()
    
    // MARK: - Presenter
    var presenter: FeedPresenter?
    
    // MARK: - Subviews
    lazy private(set) var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.placeholder = "Search..."
        sc.searchBar.delegate = self
        sc.searchBar.sizeToFit()
        
        return sc
    }()
    
    lazy private(set) var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        tv.rowHeight = UITableViewAutomaticDimension
        tv.estimatedRowHeight = 100
        tv.tableHeaderView = searchController.searchBar
        tv.tableFooterView = UIView()
        tv.allowsSelection = false
        tv.keyboardDismissMode = .onDrag
        
        return tv
    }()
    
    var subscription: Disposable?
    var dismissSubscription: Disposable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.safeAreaTopAnchor.constraint(equalTo: view.safeAreaTopAnchor),
            tableView.safeAreaLeftAnchor.constraint(equalTo: view.safeAreaLeftAnchor),
            tableView.safeAreaRightAnchor.constraint(equalTo: view.safeAreaRightAnchor),
            tableView.safeAreaBottomAnchor.constraint(equalTo: view.safeAreaBottomAnchor)
            ])
        
        searchController.searchBar.rx.text.orEmpty
            .debounce(1, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { (query) in
                self.presenter?.searchProducts(for: query)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - IFeedView
    func reloadData() {
        tableView.reloadData()
    }
    
    func setProducts(products: [Product]) {
        self.products = products
    }
    
    func appendProducts(products: [Product]) {
        self.products.append(contentsOf: products)
    }
}

// MARK: - UISearchResultsUpdating
extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}

// MARK: - UISearchBarDelegate
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.previouslySearchedString = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = presenter?.previouslySearchedString
    }
}

extension FeedViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as? ProductCell else {
            return UITableViewCell()
        } 
        
        cell.viewModel = ProductViewModel(product: products[indexPath.row])
        cell.configure()
        
        return cell
    }
}

