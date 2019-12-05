//
//  DetailRouteTableViewCell.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class DetailRouteTableViewCell: UITableViewCell {
    
    var viewModel: DetailRouteTableViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startPlaceLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var placeHolderImage: UIImageView!
    
    @IBOutlet weak var dotsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupViewModel() {
        startTimeLabel.text = viewModel?.startTime
        startPlaceLabel.text = viewModel?.startPlace
        instructionsLabel.text = viewModel?.instructions
        
        modeImage.image = UIImage(named: "walk")
        
        if let image = viewModel?.placeHolderImage {
            placeHolderImage.image = UIImage(named: image)
        }
        
        if let isHidden = viewModel?.isHiddenDots {
            dotsView.isHidden = isHidden
            modeImage.isHidden = isHidden
        }
    }
    
}
