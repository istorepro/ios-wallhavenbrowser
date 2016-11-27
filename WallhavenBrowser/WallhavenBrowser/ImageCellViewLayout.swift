//
//  ImageCellViewLayout.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit

class ImageCellViewLayout: UICollectionViewLayout {
    
    //MARK: Properties
    
    let heightModulo: Float = 40.0
    let numberOfColumns = 2
    
    var delegate: PinterestLayoutDelegate!
    var columns = [Float]()
    
    private var itemsAttributes = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat  = 0.0
    
    var columnCount: Int {
        get{
            return delegate.numberOfColumnsInCollectionView(collectionView: collectionView!)
        }
    }
    
    var columnWidth: Float{
        var width = Float((collectionView?.bounds.size.width)!) / Float(columnCount)
        width = roundf(Float(width))
        return width
    }
    
    //MARK: Functions
    
    override var collectionViewContentSize: CGSize{
        get{
            var size = collectionView?.bounds.size
            
            let columnIndex = longestColumnIndex()
            let columnHeight = columns[columnIndex]
            size?.height = CGFloat(columnHeight)
            
            return size!
        }
    }
    
    override func prepare() {
        columns = [Float](repeatElement(0, count: columnCount))
        let itemsCount = Int((collectionView?.numberOfItems(inSection: 0))!)
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(row: index, section: 0)
            
            let columnIndex = getShortestColumnIndex()
            let xOffset = Float(columnIndex) * columnWidth
            let yOffset = columns[columnIndex]
            
            var itemWidth: Float = 0.0
            var itemHeight: Float = 0.0
            
            let itemRelativeHeight = delegate.collectionView(collectionView: collectionView!, relativeHeightForItemAtIndexPath: indexPath)
            
            if(canUseDoubleColumnOnIndex(index: columnIndex) && delegate.collectionView(collectionView: collectionView!, isDoubleColumnAtIndexPath: indexPath)){
                
                itemWidth = columnWidth * Float(2)
                itemHeight = Float(itemRelativeHeight) * itemWidth
                itemHeight = itemHeight - itemHeight.truncatingRemainder(dividingBy: heightModulo)
                
                columns[columnIndex] = yOffset + itemHeight
                columns[columnIndex + 1] = yOffset + itemHeight
            } else {
                
                itemWidth = columnWidth
                itemHeight = Float(itemRelativeHeight) * itemWidth
                itemHeight = itemHeight - itemHeight.truncatingRemainder(dividingBy: heightModulo)
                
                columns[columnIndex] = yOffset + itemHeight
            }
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: CGFloat(xOffset),
                                      y: CGFloat(yOffset),
                                      width: CGFloat(itemWidth),
                                      height: CGFloat(itemHeight))
            itemsAttributes.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in itemsAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemsAttributes[indexPath.row]
    }
    
    //MARK: Private
    
    private func getShortestColumnIndex() -> Int{
        var shortestColumnIndex = 0
        var shortestVal = MAXFLOAT
        
        for index in 0..<columns.count{
            let val = columns[index]
            if(val < shortestVal){
                shortestVal = val
                shortestColumnIndex = index
            }
        }
     
        return shortestColumnIndex
    }
    
    private func longestColumnIndex() -> Int {
        var longestColumnIndex = 0
        var longestVal = Float(0)
        
        for index in 0..<columns.count{
            let val = columns[index]
            if(val > longestVal){
                longestVal = val
                longestColumnIndex = index
            }
        }
        
        return longestColumnIndex
    }
    
    private func canUseDoubleColumnOnIndex(index: Int) -> Bool {
        var canUseDoubleColumn = false
        
        if(index < numberOfColumns-1){
            canUseDoubleColumn = columns[index] == columns[index + 1]
        }
        
        return canUseDoubleColumn
    }
}
