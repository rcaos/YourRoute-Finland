//
//  SearchView.swift
//  YourRoute
//
//  Created by Jeans on 11/29/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    
    func searchViewDelegate(_ searchView: SearchView, didChangeSource source: ResultListViewModel)
    
    func searchViewDelegate(_ searchView: SearchView, planningTrip searchModel: SearchViewModel?)
    
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
    
    //@IBOutlet weak var invertedDestinationImageView: UIImageView!
    @IBOutlet weak var arrowButton: UIButton!
    
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
        setupGestures()
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
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .fill
        horizontalStackView.axis = .horizontal
        
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
    }
    
    func setupSearchBars() {
        let customFrame = CGRect(x: 0, y: 0, width: superView.frame.width , height: 56)
        
        originSearchBar = UISearchBar(frame: customFrame)
        originSearchBar.delegate = self
        configAppearance(with: .normal, in: .origin)
        
        destinationSearchBar = UISearchBar(frame: customFrame)
        destinationSearchBar.delegate = self
        configAppearance(with: .normal, in: .destination)
    }
    
    func configAppearance(with state: SearchBarState, in barType: SearchViewModel.SearchBarType) {
        let searchBar = getSearchBar(for: barType)
        
        switch state {
        case .normal:
            setNormalState(for: searchBar)
        case .highlight:
            setHighlightState(for: searchBar)
        }
    }
    
    private func setNormalState(for searchBar: UISearchBar) {
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.textColor = UIColor.gray
            textfield.layer.borderWidth = 0
            
            let defaultColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
            textfield.layer.borderColor = defaultColor
            
            textfield.layer.cornerRadius = 0
        }
    }
    
    private func setHighlightState(for searchBar: UISearchBar) {
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchBar.tintColor = UIColor(red: 65/255, green: 92/255, blue: 185/255, alpha: 1.0)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor(red: 65/255, green: 92/255, blue: 185/255, alpha: 1.0)
            
            textfield.layer.borderWidth = 1.0
            textfield.layer.borderColor = UIColor(red: 65/255, green: 92/255, blue: 185/255, alpha: 1.0).cgColor
            textfield.layer.cornerRadius = 5.0
        }
    }
    
    func setupElements() {
        arrowButton.setImage( UIImage(named: "arrow") , for: .normal)
        arrowButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        arrowButton.tintColor = UIColor(red: 217/255, green: 55/255, blue: 46/255, alpha: 1.0)
        
        verticalStackView.addArrangedSubview(originSearchBar)
        verticalStackView.addArrangedSubview(destinationSearchBar)
    }
    
    //MARK: - Gestures
    
    func setupGestures() {
        arrowButton.addTarget(self, action: #selector(self.closeAction(sender:)), for: .touchUpInside)
    }
    
    @objc func closeAction(sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.togglePlaces()
    }
    
    //MARK: - Bindables
    
    func setupBindables() {
        viewModel?.changeDataSource.bind({[weak self] source in
            guard let strongSelf = self, let source = source else { return }
            strongSelf.delegate?.searchViewDelegate(strongSelf, didChangeSource: source)
        })
        
        viewModel?.selectPlace = { [weak self] text, type in
            guard let strongSelf = self else { return }
            strongSelf.selectPlace(with: text, at: type)
        }
        
        viewModel?.changeAppearance = { [weak self] state, barType in
            guard let strongSelf = self else { return }
            strongSelf.configAppearance(with: state, in: barType)
        }
        
        viewModel?.planningTrip = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.searchViewDelegate(strongSelf, planningTrip: strongSelf.viewModel)
        }
    }
    
    func selectPlace(with text: String, at barType: SearchViewModel.SearchBarType) {
        let searchBar = getSearchBar(for: barType)
        searchBar.text = text
        configAppearance(with: .highlight, in: barType)
    }
}

//MARK: - UISearchBarDelegate

extension SearchView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.textDidChange(with: searchText, in: getTypeBar(searchBar: searchBar) )
        
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
        //print("end searchBarTextDidEndEditing: [\(searchBar.text)]")
    }
}

//MARK: - Interactions with ViewModel

extension SearchView {
    
    func executeSearch(with text: String, in searchBar: UISearchBar) {
        let selectedBar = getTypeBar(searchBar: searchBar)
        viewModel?.searchPlace(with: text, in: selectedBar)
    }
    
    private func getTypeBar(searchBar: UISearchBar) -> SearchViewModel.SearchBarType {
        if searchBar == originSearchBar {
            return .origin
        } else {
            return .destination
        }
    }
    
    private func getSearchBar(for type: SearchViewModel.SearchBarType) -> UISearchBar {
        switch type {
        case .origin:
            return originSearchBar
        case .destination:
            return destinationSearchBar
        }
    }
}

//MARK: - Enum State

extension SearchView {
    
    enum SearchBarState {
        
        case normal
        
        case highlight
    }
    
}

