//
//  WaterFlowLayout.swift
//  spot
//
//  Created by Hikaru on 2015/01/05.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import UIKit
import Foundation

protocol WaterFlowLayoutDelegate {
    func heightForRowInCollectionView(collectionView: UICollectionView, usingLayout layout: WaterFlowLayout, atIndexPath indexPath: NSIndexPath) -> Float;
}

class WaterFlowLayout: UICollectionViewLayout {
    var numberOfColumns: Int = 3
    var interItemSpacing: Float = 12.0
    var waterFlowDelegate: WaterFlowLayoutDelegate?
    
    private var lastYValueForColumn: [Int: Float] = Dictionary()
    private var layoutInfo: [NSIndexPath: UICollectionViewLayoutAttributes] = Dictionary()
    
    override func prepareLayout() {
        var currentColumn = 0
        let fullWidth = Float(UIScreen.mainScreen().bounds.size.width)
        let availableSpaceExcludingPadding = fullWidth - (interItemSpacing * (Float(numberOfColumns) + 1.0))
        let itemWidth = availableSpaceExcludingPadding / Float(numberOfColumns)
        setupLastYValueForColumnDictionary()
        
        var indexPath: NSIndexPath?
        let numberOfSections = collectionView?.numberOfSections()
        for section in 0..<numberOfSections! {
            let numberOfItems = collectionView?.numberOfItemsInSection(section)
            for row in 0..<numberOfItems! {
                indexPath = NSIndexPath(forItem: row, inSection: section)
                
                var itemAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath!)
                
                var shortest = shortestColumnAndOriginY()
                
                var originX = interItemSpacing + (interItemSpacing + itemWidth) * Float(shortest.column)
                var originY = shortest.originY
                
                var height = waterFlowDelegate?.heightForRowInCollectionView(collectionView!, usingLayout: self, atIndexPath: indexPath!)
                itemAttributes.frame = CGRect(x: Double(originX), y: Double(originY), width: Double(itemWidth), height: Double(height!))
                originY += height!
                originY += interItemSpacing
                
                lastYValueForColumn[shortest.column] = originY
                layoutInfo[indexPath!] = itemAttributes
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var allAttributes: [UICollectionViewLayoutAttributes] = Array()
        for (indexPath, attributes) in layoutInfo {
            if CGRectIntersectsRect(rect, attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        var currentColumn = 0
        var maxHeight: Float = 0
        
        while currentColumn < numberOfColumns {
            if let height = self.lastYValueForColumn[currentColumn] {
                if height > maxHeight {
                    maxHeight = height
                }
            }
            currentColumn++
        }
        return CGSize(width: Double(collectionView!.bounds.size.width), height: Double(maxHeight))
    }
    
    private func setupLastYValueForColumnDictionary() {
        for i in 0..<numberOfColumns {
            lastYValueForColumn[i] = 0
        }
    }
    
    private func shortestColumnAndOriginY() -> (column: Int,originY: Float){
        var shortestColumn: Int = 0
        var shortestOriginY: Float = MAXFLOAT
        
        for (column, originY) in lastYValueForColumn {
            if originY < shortestOriginY {
                shortestOriginY = originY
                shortestColumn = column
            } else if originY == shortestOriginY && shortestColumn > column {
                shortestColumn = column
                shortestOriginY = originY
            }
        }
        
        return (shortestColumn, shortestOriginY)
    }
}