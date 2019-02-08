//
//  CarouselSlide.swift
//  WinkNavigation
//
//  Created by Derek Carter on 2/8/19.
//  Copyright © 2019 Derek Carter. All rights reserved.
//

import UIKit

public class CarouselSlide : NSObject {
    
    public var slideImage: UIImage?
    public var slideTitle: String?
    public var slideDescription: String?
    
    
    public init(image: UIImage?, title: String?, description: String?) {
        slideImage = image
        slideTitle = title
        slideDescription = description
    }
    
}
