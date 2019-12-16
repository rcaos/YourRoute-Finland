//
//  ErrorView.swift
//  YourRoute
//
//  Created by Jeans on 12/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class ErrorView: NibView {
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tryButton: UIButton!
    
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
        
        imageView.image = UIImage(named: "errorView01")
        
        messageLabel.text = "Can't find a way there"
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.textColor = UIColor(red: 58/255, green: 63/255, blue: 66/255, alpha: 1.0)
        
        tryButton.setTitle("Try again", for: .normal)
        tryButton.contentHorizontalAlignment = .center
    }
}

