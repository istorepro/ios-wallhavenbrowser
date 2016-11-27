//
//  PinterestLayout.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 26.11.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

class PinterestLayout : PinterestLayoutDelegate {
    
    //MARK: Properties
    
    let columnProbability: UInt32 = 40
    let numberOfColumns = 2
    var dataSource = [Photo]()
    
    //MARK: Functions
    
    func collectionView(collectionView:UICollectionView, relativeHeightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        var retVal = CGFloat(1.0)
        let photo = dataSource[indexPath.row]
        
        if(photo.height != 0){
            retVal = CGFloat(photo.height)
        } else {
            let isDoubleColumn = self.collectionView(collectionView: collectionView, isDoubleColumnAtIndexPath: indexPath)
            if (isDoubleColumn){
                retVal = 0.75
            }
            
            let extraRandomHeight = arc4random() % 25
            retVal += CGFloat(Float(extraRandomHeight) / 100.0)
            photo.height = Float(retVal)
        }
        
        return retVal
    }
    
    func collectionView(collectionView:UICollectionView, isDoubleColumnAtIndexPath indexPath:IndexPath) -> Bool{
        let photo = dataSource[indexPath.row]
        if(photo.type == .Undefined){
            let random = arc4random() % 100
            photo.type = random < columnProbability ? .Double : .Single
        }
        
        return photo.type == .Double
    }
    
    func numberOfColumnsInCollectionView(collectionView:UICollectionView) -> Int{
        return numberOfColumns
    }
}
