//
//  SearchView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    
    func searchViewDelegate(_ searchMoviesResultController: SearchView, didChangeSource source: ResultListViewModel)
    
}

class SearchView: NibView {
    
    var viewModel: SearchViewModel? {
        didSet {
            setupBindables()
        }
    }
    
    weak var delegate: SearchViewDelegate?
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var rounderView: UIView!
    
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var invertedDestinationImageView: UIImageView!
    
    var originSearchBar: UISearchBar!
    var destinationSearchBar: UISearchBar!
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    //MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        setupView()
        setupStackViews()
        setupSearchBars()
        setupElements()
    }
    
    func setupView() {
        superView.backgroundColor = .clear
        
        rounderView.layer.cornerRadius = 8
        rounderView.layer.borderWidth = 1
        rounderView.layer.borderColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0).cgColor
        rounderView.backgroundColor = UIColor(red:245/255, green:246/255, blue:247/255, alpha:1.0)
        
        centerView.backgroundColor = .clear
    }
    
    func setupStackViews() {
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
    }
    
    func setupSearchBars() {
        let customFrame = CGRect(x: 0, y: 0, width: superView.frame.width , height: 56)
        originSearchBar = UISearchBar(frame: customFrame)
        destinationSearchBar = UISearchBar(frame: customFrame)
        
        originSearchBar.delegate = self
        destinationSearchBar.delegate = self
    }
    
    func setupElements() {
        invertedDestinationImageView.image = UIImage(named: "arrow")
        invertedDestinationImageView.contentMode = .scaleAspectFit
        
        verticalStackView.addArrangedSubview(originSearchBar)
        verticalStackView.addArrangedSubview(destinationSearchBar)
    }
    
    func setupBindables() {
        viewModel?.changeDataSource.bind({[weak self] source in
            guard let strongSelf = self, let source = source else { return }
            strongSelf.delegate?.searchViewDelegate(strongSelf, didChangeSource: source)
        })
        
        viewModel?.selectPlace = { [weak self] text, type in
            guard let strongSelf = self else { return }
            strongSelf.selectPlace(with: text, at: type)
        }
    }
    
    func selectPlace(with text: String, at bar: SearchViewModel.SearchBarType) {
        switch bar {
        case .origin:
            originSearchBar.text = text
            originSearchBar.showsScopeBar = true
        case .destination:
            destinationSearchBar.text = text
        }
    }
}

extension SearchView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else { return }
        
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.executeSearch(with: searchText, in: searchBar)
        }
        
        //Wait 400 miliseconds after last typing
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400) , execute: requestWorkItem)
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //print("terminó de searchBarTextDidEndEditing")
    }
}

//MARK: - Interactions with ViewModel

extension SearchView {
    
    func executeSearch(with text: String, in searchBar: UISearchBar) {
        let selectedBar: SearchViewModel.SearchBarType
        if searchBar == originSearchBar {
            selectedBar = .origin
        } else {
            selectedBar = .destination
        }
        
        //print("--call viewModel with Text: [\(text)]")
        viewModel?.searchPlace(with: text, in: selectedBar)
    }
}

