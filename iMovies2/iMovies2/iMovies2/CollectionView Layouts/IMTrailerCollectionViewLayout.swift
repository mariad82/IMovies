//
//  IMTrailerCollectionViewLayout.swift
//  iMovies
//
//  Created by Maria Davidenko on 17/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit

protocol IMTrailerCollectionViewLayoutDelegate: AnyObject {

    func theNumberOfItemsInCollectionView() -> Int
}


class IMTrailerCollectionViewLayout: UICollectionViewFlowLayout {

    weak var delegate: IMTrailerCollectionViewLayoutDelegate?
    
    let activeDistance = 200
    let zoomFactor = 0.3
    let startAngle : CGFloat = 270.0
    let rotation  = 5.0
    
    override init() {
        
        super.init()
        self.itemSize = CGSize(width: 100 , height: 100)
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.minimumLineSpacing = 10.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.itemSize = CGSize(width: 200, height: 200)
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.minimumLineSpacing = 10.0
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attributesArray = super.layoutAttributesForElements(in: rect)        
        for attributes in attributesArray! {
            
            let indexPath = attributes.indexPath
            let row = indexPath.row
            
            if row % 2 != 0 && row != 0 {
                
                let randomOffset = Double.random(in: 20..<40)
                attributes.center = CGPoint(x: attributes.center.x - CGFloat(randomOffset), y: attributes.center.y)

            }
        }
        return attributesArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false
    }
    
}


extension Double {
    
    func deg2rad() -> Double {
        
        return self * (.pi / 180.0)
    }
}
