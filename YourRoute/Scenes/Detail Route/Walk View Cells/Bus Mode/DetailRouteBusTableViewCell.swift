//
//  DetailRouteBusTableViewCell.swift
//  YourRoute
//
//  Created by Jeans on 12/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class DetailRouteBusTableViewCell: UITableViewCell {
    
    var viewModel: DetailRouteBusTableViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startPlaceLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    
    @IBOutlet weak var busDescriptionLabel: UILabel!
    
    @IBOutlet weak var stopsCountLabel: UILabel!
    @IBOutlet weak var durationTripLabel: UILabel!
    
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var placeHolderImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupViewModel() {
        startTimeLabel.text = viewModel?.startTime
        startPlaceLabel.text = viewModel?.startPlace
        platformLabel.text = viewModel?.platForm
        
        busDescriptionLabel.text = viewModel?.busDescription
        
        stopsCountLabel.text = viewModel?.stopsCount
        durationTripLabel.text = viewModel?.durationTrip
        
        modeImage.image = UIImage(named: "bus2")
        placeHolderImage.image = UIImage(named: "circle")
    }
    
}
