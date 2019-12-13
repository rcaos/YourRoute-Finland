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
    
    func searchViewDelegateDidEndResults(_ searchView: SearchView)
    
}

class SearchView: NibView {
    
    var viewModel: SearchViewModel? {
        didSet {
            setupBindables()
        }
    }
    
    weak var delegate: SearchViewDelegate?
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var centerView: UIView!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var placesView: UIView!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var configView: UIView!
    
    @IBOutlet weak var menuBackgroundButton: UIButton!
    @IBOutlet weak var menuImage: UIImageView!
    
    @IBOutlet weak var placesStackView: UIStackView!
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var placeMarkImage: UIImageView!
    
    @IBOutlet weak var ellipsisButton: UIButton!
    @IBOutlet weak var ellipsisImage: UIImageView!
    
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    
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
        
        setupMenuView()
        setupPlacesView()
        setupSearchBarView()
        setupConfigView()
        
        setupActions()
        
        setupGestures()
    }
    
    func setupView() {
        superView.backgroundColor = .white
        centerView.backgroundColor = .white
        
        let contactRect = CGRect(x: -200, y: 100, width: frame.width * 2, height: 4)
        superView.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        superView.layer.shadowRadius = 4
        superView.layer.shadowOpacity = 1
        superView.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func setupMenuView() {
        menuImage.image = UIImage(named: "menu")
    }
    
    func setupPlacesView() {
        placesStackView.alignment = .center
        placesStackView.distribution = .fillEqually
        placesStackView.axis = .vertical
        
        dotImage.image = UIImage(named: "dot-bold")
        moreImage.image = UIImage(named: "more-vertical")
        placeMarkImage.image = UIImage(named: "placemark")
    }
    
    func setupSearchBarView() {
        setupSearchBars()
        setupStackViewBars()
    }
    
    func setupConfigView() {
        ellipsisImage.image = UIImage(named: "ellipsis")
        arrowImage.image = UIImage(named: "arrow-swap")
    }
    
    func setupSearchBars() {
        let customFrame = CGRect(x: 0, y: 0, width: superView.frame.width , height: 56)
        
        originSearchBar = UISearchBar(frame: customFrame)
        originSearchBar.delegate = self
        originSearchBar.placeholder = "Origin"
        originSearchBar.setImage( UIImage(), for: .search, state: .normal)
        originSearchBar.setPositionAdjustment(UIOffset(horizontal: -20, vertical: 0), for: .search)
        configAppearance(with: .normal, in: .origin)
        
        destinationSearchBar = UISearchBar(frame: customFrame)
        destinationSearchBar.delegate = self
        destinationSearchBar.placeholder = "Destination"
        destinationSearchBar.setImage( UIImage(), for: .search, state: .normal)
        destinationSearchBar.setPositionAdjustment(UIOffset(horizontal: -20, vertical: 0), for: .search)
        configAppearance(with: .normal, in: .destination)
    }
    
    func setupStackViewBars() {
        searchStackView.alignment = .fill
        searchStackView.distribution = .fillEqually
        searchStackView.axis = .vertical
        
        searchStackView.addArrangedSubview(originSearchBar)
        searchStackView.addArrangedSubview(destinationSearchBar)
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
            textfield.layer.borderWidth = 1.0
            
            let defaultColor = UIColor(red: 213/255, green: 215/255, blue: 219/255, alpha: 1.0).cgColor
            textfield.layer.borderColor = defaultColor
            
            textfield.layer.cornerRadius = 5
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
    
    //MARK: - Actions
    
    func setupActions() {
        menuBackgroundButton.addTarget(self, action: #selector(self.menuAction(sender:)), for: .touchUpInside)
        
        ellipsisButton.addTarget(self, action: #selector(self.moreAction(sender:)), for: .touchUpInside)
        
        arrowButton.addTarget(self, action: #selector(self.swapAction(sender:)), for: .touchUpInside)
    }
    
    @objc func menuAction(sender: UIButton) {
        print("menuAction")
        //guard let viewModel = viewModel else { return }
        
        //MARK: - TODO
        //viewModel.togglePlaces()
    }
    
    @objc func moreAction(sender: UIButton) {
        print("moreAction")
        //guard let viewModel = viewModel else { return }
        
        //MARK: - TODO
        //viewModel.togglePlaces()
    }
    
    @objc func swapAction(sender: UIButton) {
        print("swapAction")
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
            strongSelf.hideKeyboard()
        }
    }
    
    func selectPlace(with text: String?, at barType: SearchViewModel.SearchBarType) {
        let searchBar = getSearchBar(for: barType)
        searchBar.text = text
        
        if let text = text {
            if text.isEmpty {
                configAppearance(with: .normal, in: barType)
            } else {
                configAppearance(with: .highlight, in: barType)
            }
        } else {
            configAppearance(with: .normal, in: barType)
        }
        
        hideKeyboard()
    }
    
    func hideKeyboard() {
        endEditing(true)
    }
    
    private func setupGestures() {
        let simpleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        addGestureRecognizer(simpleTap)
    }
    
    @objc func handleSingleTap(sender:UITapGestureRecognizer){
        delegate?.searchViewDelegateDidEndResults(self)
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

