//
//  HorizontalCollectionView.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
class HorizontalCollectionView:UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.scrollDirection = scrollDirection
        self.collectionViewLayout = flowLayout
    }
    
}