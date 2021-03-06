//
//  ProductCell.swift
//  FeedReader
//
//  Created by Ron Daryl Magno on 2/5/18.
//  Copyright © 2018 Ron Daryl Magno. All rights reserved.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {
    private struct Dimensions {
        static var spacing: CGFloat = 8
    }
    
    var viewModel: ProductViewModel?

    // MARK: - Subviews
    lazy private(set) var productView: ProductView = {
        let pv = ProductView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        
        return pv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    // TODO: Implement this if needed
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(productView)
        NSLayoutConstraint.activate([
            productView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.spacing),
            productView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Dimensions.spacing),
            productView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Dimensions.spacing),
            productView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Dimensions.spacing),
            ])
        
        productView.titleLabel.font = UIFont(name: "Avenir-Book", size: 15)
        productView.pubDateLabel.font = UIFont(name: "Avenir-Book", size: 13)
        productView.ratingLabel.font = UIFont(name: "Avenir-Book", size: 13)
    }
    
    func configure() {
        // TODO: Move this view model
        productView.titleLabel.text = viewModel?.title
        productView.pubDateLabel.text = viewModel?.pubDate
        productView.ratingLabel.text = viewModel?.rating
        
        if let url = viewModel?.imageUrl {
            productView.prodImage.kf.setImage(with: url)
        }
    }
}

// MARK: - ViewReusable
extension ProductCell: ViewReusable {
    static var reuseId: String {
        return String(describing: self)
    }
}
