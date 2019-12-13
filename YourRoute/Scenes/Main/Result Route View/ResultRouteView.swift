//
//  ResultView.swift
//  YourRoute
//
//  Created by Jeans on 12/9/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

protocol ResultRouteViewDelegate: class {
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didSelectRouteDetail detail: DetailRouteViewModel)
    
    func resultRouteViewDelegate(_ resultView: ResultRouteView, didChangeItinerarie mapViewModel: MainMapViewModel)
    
}

class ResultRouteView: UIView {
    
    var viewModel: ResultRouteViewModel? {
        didSet {
            setupViewModel()
        }
    }
    
    weak var delegate: ResultRouteViewDelegate?
    
    var flowLayout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        //collectionView.isPagingEnabled = true
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var indexOfCellBeforeDragging = 0
    
    private var lastIndexSelected: Int? {
        didSet {
            if let newIndex = lastIndexSelected {
                if let mapViewModel = viewModel?.buildMapViewModel(for: newIndex) {
                    delegate?.resultRouteViewDelegate(self, didChangeItinerarie: mapViewModel)
                }
            }
        }
    }
    
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    func setupUI() {
        backgroundColor = .clear
        
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor) ])
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let nibName = UINib(nibName: "ItinerarieCollectionCellView", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "ItinerarieCollectionCellView")
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayout() {
        let inset: CGFloat = 20
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        let width = frame.size.width - (inset * 2)
        let height = frame.size.height
        flowLayout.itemSize = CGSize(width: width, height: height )
        
        flowLayout.minimumInteritemSpacing = 0
    }
    
    private func indexOfMajorCell() -> Int {
        let itemWidth = flowLayout.itemSize.width
        
        let proportionalOffset = collectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        
        return safeIndex
    }
    
    func setupViewModel() {
        guard let viewModel = viewModel else { return }
        
        collectionView.reloadData()
        
        viewModel.showRoute = {[weak self] index in
            self?.lastIndexSelected = 0
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ResultRouteView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.itinerariesCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItinerarieCollectionCellView", for: indexPath) as? ItinerarieCollectionCellView  else {
            fatalError("Could not cast value of type 'UICollectionViewCell'")
        }
        
        cell.viewModel = viewModel?.itinerariesCells[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ResultRouteView: UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let safeIndex = indexOfMajorCell()
        
        indexOfCellBeforeDragging = safeIndex
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        
        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()
        
        // calculate conditions:
        let dataSourceCount = collectionView(collectionView , numberOfItemsInSection: 0)
        
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        var newIndex = 0
        
        if didUseSwipeToSkipCell {
            
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = flowLayout.itemSize.width * CGFloat(snapToIndex)
            
            // Damping equal 1 => no oscillations => decay animation:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
            newIndex = Int(toValue / flowLayout.itemSize.width)
            
        } else {
            // This is a much better way to scroll to a cell:
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            flowLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            newIndex = indexPath.row
        }
        
        checkIndex(for: newIndex)
    }
    
    func checkIndex(for newIndex: Int) {
        if let lastIndex = lastIndexSelected {
            if newIndex != lastIndex {
                lastIndexSelected = newIndex
            }
        } else {
            lastIndexSelected = newIndex
        }
    }
}

//MARK: - ItinerarieCollectionCellViewDelegate

extension ResultRouteView: ItinerarieCollectionCellViewDelegate {
    
    func itinerarieCollectionCellView(_ resultView: UICollectionViewCell, didSelectRouteDetail detail: DetailRouteViewModel) {
        delegate?.resultRouteViewDelegate(self, didSelectRouteDetail: detail)
    }
}
