//
//  CarouselView.swift
//  WinkNavigation
//
//  Created by Derek Carter on 2/8/19.
//  Copyright © 2019 Derek Carter. All rights reserved.
//

import UIKit

final public class CarouselView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Public properties
    public var interval: Double?
    public var slides: [CarouselSlide] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.slides.count
                self.pageControl.size(forNumberOfPages: self.slides.count)
            }
        }
    }
    
    // Private properties
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.bounces = false
        collectionView.clipsToBounds = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    }()
    
    private var timer: Timer = Timer()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Setup view
        backgroundColor = UIColor.clear
        
        // Setup collection view
        collectionView.addGestureRecognizer(tapGesture)
        addSubview(collectionView)
        let collectionViewTop = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let collectionViewBottom = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let collectionViewLeft = NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        let collectionViewRight = NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([collectionViewTop, collectionViewBottom, collectionViewLeft, collectionViewRight])
        
        // Setup page control
        addSubview(pageControl)
        let pageControlTop = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -4)
        let pageControlHeight = NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 22)
        let pageControlLeft = NSLayoutConstraint(item: pageControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 4)
        let pageControlRight = NSLayoutConstraint(item: pageControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -4)
        NSLayoutConstraint.activate([pageControlTop, pageControlHeight, pageControlLeft, pageControlRight])
        bringSubviewToFront(pageControl)
    }
    
    
    // MARK: - GestureRecognizer Methods
    
    @objc private func tapGestureHandler() {
        self.nextSlide()
    }
    
    
    // MARK: - Public Methods
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval ?? 1.0, target: self, selector: #selector(tapGestureHandler), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    public func nextSlide() {
        if let indexPath = selectedIndexPath() {
            if indexPath.item == (slides.count-1) {
                let indexPathToShow = IndexPath(item: 0, section: 0)
                self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
            }
            else {
                let indexPathToShow = IndexPath(item: (indexPath.item + 1), section: 0)
                self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        else {
            print("Could not find current indexPath")
        }
    }
    
    public func previousSlide() {
        if let indexPath = selectedIndexPath() {
            if indexPath.item == 0 {
                let indexPathToShow = IndexPath(item: slides.count-1, section: 0)
                self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
            }
            else {
                let indexPathToShow = IndexPath(item: (indexPath.item - 1), section: 0)
                self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        else {
            print("Could not find current indexPath")
        }
    }
    
    public func selectedIndexPath() -> IndexPath? {
        var rect = CGRect()
        rect.origin = collectionView.contentOffset
        rect.size = collectionView.bounds.size
        let point = CGPoint(x: rect.midX, y: rect.midY)
        let indexPath: IndexPath? = collectionView.indexPathForItem(at: point)
        return indexPath
    }
    
    
    // MARK: - UICollectionViewDataSource Methods
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    
    // MARK: - UICollectionViewDelegate Methods
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        cell.slide = self.slides[indexPath.item]
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: - UIScrollViewDelegate Methods
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(currentPage)
    }
    
}
