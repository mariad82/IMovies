//
//  IMTrailerCollectionViewLayout.swift
//  iMovies
//
//  Created by Maria Davidenko on 17/03/2020.
//  Copyright © 2020 Maria Davidenko. All rights reserved.
//

import UIKit

protocol IMGenresCollectionViewLayoutDelegate: AnyObject {

    func theNumberOfItemsInCollectionView() -> Int
}


class IMGenresCollectionViewLayout: UICollectionViewFlowLayout {

    weak var delegate: IMGenresCollectionViewLayoutDelegate?
    
    let activeDistance = 200
    let zoomFactor = 0.3
    let startAngle : CGFloat = 270.0
    let rotation  = 20.0
    let collectionViewDefaultWidth : CGFloat  = 400.0
    let screenSize = UIScreen.main.bounds
    var width:CGFloat = 0
    
    override init() {
        

        super.init()
        
        width = CGFloat(self.collectionView?.bounds.size.width ?? collectionViewDefaultWidth)
        self.scrollDirection = .vertical
        
        self.itemSize = CGSize(width: 105, height: 105)
        self.sectionInset = UIEdgeInsets(top: 0, left: width / 10, bottom: 0, right: width / 10)

    }
    
    required init?(coder aDecoder: NSCoder) {
        

        super.init(coder: aDecoder)
        
        width = CGFloat(self.collectionView?.bounds.size.width ?? collectionViewDefaultWidth)
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 0, left: width / 10, bottom: 0, right: width / 10)
        self.itemSize = CGSize(width: 105, height: 105)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let attributesArray = super.layoutAttributesForElements(in: rect)
        
        for attributes in attributesArray! {
            
            attributes.size = CGSize(width: 105, height: 105)
            attributes.transform = CGAffineTransform(rotationAngle: CGFloat(rotation.deg2rad()))
        }
        return attributesArray
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        return false
    }
    
}

