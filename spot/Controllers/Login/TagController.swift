//
//  TagController.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class TagController :CommonController{
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    ////////////////collectionView     ////////////////////
    //////////////////////////////////////////////////
    
    // #pragma mark UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_tag", forIndexPath: indexPath) as CellTag
        
        cell.titleLabel.text = "tag" + String(indexPath.row)
        cell.checked(true)
        return cell
    }
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as CellTag
        cell.checked( !cell.IsCheckeded )
        println("selected")
        return true
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            return CGSizeMake(90, 60)
    }
}