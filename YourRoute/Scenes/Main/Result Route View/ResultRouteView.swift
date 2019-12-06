//
//  ResultRouteView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ResultRouteViewDelegate: class {
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didSelectRouteDetail detail: DetailRouteViewModel)
    
}

class ResultRouteView: NibView {
    
    var viewModel: ResultRouteViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    weak var delegate: ResultRouteViewDelegate?
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var rounderView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
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
        
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = UIColor(red: 185/255, green: 72/255, blue: 52/255, alpha: 1.0)
        
        infoLabel.numberOfLines = 1
        infoLabel.textAlignment = .center
        infoLabel.textColor = .red
        
        detailButton.setTitle("VER DETALLES DE RUTA", for: .normal)
        detailButton.backgroundColor = UIColor(red: 185/255, green: 72/255, blue: 52/255, alpha: 1.0)
        detailButton.setTitleColor(.white, for: .normal)
        detailButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        
        detailButton.addTarget(self, action: #selector(self.actionSegue(sender:)), for: .touchUpInside)
    }
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        //UITableView,
        //Cada cell tiene una foto y una description
        
        segmentedControl.setTitle(viewModel.optimeRoute, forSegmentAt: 0)
        
        segmentedControl.setTitle(viewModel.otherRoutes, forSegmentAt: 1)
        
        infoLabel.text = viewModel.infoAboutRoute
    }
    
    @objc func actionSegue(sender: UIButton) {
        
        if let viewModel = viewModel?.buildDetailRouteViewModel() {
            delegate?.resultRouteViewDelegate(self, didSelectRouteDetail: viewModel)
        }
    }
    
}
