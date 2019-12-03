//
//  NibView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNib()
        awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Private

private extension NibView {
    
    func setupNib() {
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        let topLevelViews = nib.instantiate(withOwner: self, options: nil)
        
        let nibView = topLevelViews.first as! UIView
        nibView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(nibView, at: 0)
        
        NSLayoutConstraint.activate([
            nibView.leftAnchor.constraint(equalTo: leftAnchor),
            nibView.rightAnchor.constraint(equalTo: rightAnchor),
            nibView.topAnchor.constraint(equalTo: topAnchor),
            nibView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
}
