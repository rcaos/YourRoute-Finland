//
//  CloseView.swift
//  YourRoute
//
//  Created by Jeans on 12/10/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol CloseViewDelegate: class {
    
    func closeViewDelegateDidClose(_ searchView: CloseView)
    
}

class CloseView: NibView {
    
    weak var delegate: CloseViewDelegate?
    
    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = .clear
        superView.backgroundColor = .clear
        
        closeButton.addTarget(self, action: #selector(self.closeAction(sender:)), for: .touchUpInside)
    }
    
    @objc func closeAction(sender: UIButton) {
        delegate?.closeViewDelegateDidClose(self)
    }
}
