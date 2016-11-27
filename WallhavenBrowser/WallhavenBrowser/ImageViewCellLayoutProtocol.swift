//
//  ImageViewCellLayoutProtocol.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

protocol PinterestLayoutDelegate {
    func collectionView(collectionView:UICollectionView, relativeHeightForItemAtIndexPath indexPath:IndexPath) -> CGFloat
    func collectionView(collectionView:UICollectionView, isDoubleColumnAtIndexPath indexPath:IndexPath) -> Bool
    func numberOfColumnsInCollectionView(collectionView:UICollectionView) -> Int
}
