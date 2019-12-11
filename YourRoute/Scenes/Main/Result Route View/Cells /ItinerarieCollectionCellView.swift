//
//  ItinerarieCollectionCellView.swift
//  YourRoute
//
//  Created by Jeans on 12/9/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ItinerarieCollectionCellViewDelegate: class {
    
    func itinerarieCollectionCellView(_ resultView: UICollectionViewCell, didSelectRouteDetail detail: DetailRouteViewModel)
    
}

class ItinerarieCollectionCellView: UICollectionViewCell {
    
    var viewModel: ItinerarieCollectionCellViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    weak var delegate: ItinerarieCollectionCellViewDelegate?
    
    @IBOutlet weak var wrapperView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var walkView: UIView!
    
    @IBOutlet weak var busView: UIView!
    
    @IBOutlet weak var durationTripLabel: UILabel!
    
    @IBOutlet weak var walkDurationLabel: UILabel!
    
    @IBOutlet weak var walkDistanceLabel: UILabel!
    
    @IBOutlet weak var busDurationLabel: UILabel!
    
    @IBOutlet weak var busCountLabel: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!

    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleUI()
    }
    
    fileprivate func styleUI() {
        wrapperView.layer.cornerRadius = 5.0
        wrapperView.layer.borderWidth = 0.5
        wrapperView.layer.borderColor = UIColor.gray.cgColor
        wrapperView.clipsToBounds = true
        
        centerView.layer.cornerRadius = 5.0
        centerView.layer.borderWidth = 0.5
        centerView.layer.borderColor = UIColor.gray.cgColor
        centerView.clipsToBounds = true
        
        //73,92,152     old azul
        //231, 184, 57  old amarillo
        //185, 72, 52   old rojo
        //walkView.backgroundColor = UIColor(red: 73/255, green: 92/255, blue: 152/255, alpha: 1.0)   //old azul
        //busView.backgroundColor = UIColor(red: 231/255, green: 184/255, blue: 57/255, alpha: 1.0)   //old amarillo
        //detailButton.backgroundColor = UIColor(red: 185/255, green: 72/255, blue: 52/255, alpha: 1.0)  //old rojo
        
        //#415cb9
        walkView.backgroundColor = UIColor(red: 65/255, green: 92/255, blue: 185/255, alpha: 1.0)   //new azul
        busView.backgroundColor = UIColor(red: 245/255, green: 184/255, blue: 57/255, alpha: 1.0)  //new amarillo
        
        //#2fbc35
        detailButton.backgroundColor = UIColor(red: 47/255, green: 188/255, blue: 53/255, alpha: 1.0)  //new green
        
        //Gris de Google Maps:
        //UIColor(red: 58/255, green: 63/255, blue: 66/255, alpha: 1.0)
        
        //Un rojo más bajo, Google Maps:
        //UIColor(red: 217/255, green: 55/255, blue: 46/255, alpha: 1.0)
        
        detailButton.addTarget(self, action: #selector(self.actionSegue(sender:)), for: .touchUpInside)
    }
    
    fileprivate func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        durationTripLabel.text = viewModel.itinerarieDuration
        walkDurationLabel.text = viewModel.walkDuration
        walkDistanceLabel.text = viewModel.walkDistance
        busDurationLabel.text = viewModel.busDuration
        busCountLabel.text = viewModel.busCount
    }
    
    //MARK: - IBActions
    
    @objc func actionSegue(sender: UIButton) {
        guard let viewModel = viewModel else { return }
        
        let detailRouteViewModel = viewModel.buildDetailRouteViewModel()
        delegate?.itinerarieCollectionCellView(self, didSelectRouteDetail: detailRouteViewModel)
    }
    
}

