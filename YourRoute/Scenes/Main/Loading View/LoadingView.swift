//
//  HelperView.swift
//  YourRoute
//
//  Created by Jeans on 12/13/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class LoadingView: NibView {

    @IBOutlet weak var wrapperView: UIView!
    
    fileprivate lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    
    //MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    func setupUI() {
        setupView()
    }
    
    func setupView() {
        wrapperView.backgroundColor = .white
        
        addSubview(activityIndicatorView)
        centerInSuperview(view: activityIndicatorView)
    }
    
    func centerInSuperview(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = view.superview?.centerXAnchor {
            view.centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = view.superview?.centerYAnchor {
            view.centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }
    
}
