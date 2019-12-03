//
//  ResultRouteView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class ResultRouteView: NibView {
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var segmentedView: UIView!
    
    //MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        setupView()
    }
    
    func setupView() {
        superView.backgroundColor = .clear
        
        rounderView.layer.cornerRadius = 8
        rounderView.layer.borderWidth = 1
        rounderView.layer.borderColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0).cgColor
        rounderView.backgroundColor = UIColor(red:245/255, green:246/255, blue:247/255, alpha:1.0)
        
        centerView.backgroundColor = .clear
        
        segmentedView.backgroundColor = .clear
    }
    
}
