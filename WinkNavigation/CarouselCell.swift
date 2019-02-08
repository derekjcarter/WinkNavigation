//
//  CarouselCell.swift
//  WinkNavigation
//
//  Created by Derek Carter on 2/8/19.
//  Copyright © 2019 Derek Carter. All rights reserved.
//

import UIKit

public class CarouselCell: UICollectionViewCell {
    
    // Public properties
    public var slide: CarouselSlide? {
        didSet {
            guard let slide = slide else {
                print("No slide provided")
                return
            }
            self.setCell(fromSlide: slide)
        }
    }
    
    // Private properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.contentMode = ContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addBlackGradientLayer(frame: bounds)
        
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 38)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Setup view
        backgroundColor = UIColor.clear
        clipsToBounds = true
        
        // Setup imageView
        addSubview(imageView)
        let imageViewTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let imageViewBottom = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let imageViewLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        let imageViewRight = NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activate([imageViewTop, imageViewBottom, imageViewLeft, imageViewRight])
        
        // Setup description label
        addSubview(descriptionLabel)
        let descriptionLabelTop = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.25, constant: 0)
        let descriptionLabelBottom = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9, constant: 0)
        let descriptionLabelLeft = NSLayoutConstraint(item: descriptionLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 8)
        let descriptionLabelRight = NSLayoutConstraint(item: descriptionLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -8)
        NSLayoutConstraint.activate([descriptionLabelTop, descriptionLabelBottom, descriptionLabelLeft, descriptionLabelRight])
        
        // Setup title label
        addSubview(titleLabel)
        let titleLabelBottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .top, multiplier: 1.0, constant: 8)
        let titleLabelHeight = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let titleLabelLeft = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 8)
        let titleLabelRight = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -8)
        NSLayoutConstraint.activate([titleLabelBottom, titleLabelHeight, titleLabelLeft, titleLabelRight])
    }
    
    
    // MARK: - Cell Setter Methods
    
    private func setCell(fromSlide slide: CarouselSlide) {
        if let image = slide.slideImage {
            self.imageView.image = image
        }
        if let title = slide.slideTitle {
            self.titleLabel.text = title
        }
        if let description = slide.slideDescription {
            self.descriptionLabel.text = description
        }
    }
    
}
