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
    
    @IBOutlet weak var separatorView: UIView!

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
     
        separatorView.backgroundColor = UIColor(red: 2/255, green: 136/255, blue: 206/255, alpha: 1.0)
        //2,136, 206
    }
    
}
