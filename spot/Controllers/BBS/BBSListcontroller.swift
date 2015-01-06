//
//  BBSListcontroller.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class BBSListcontroller:CommonController,WaterFlowLayoutDelegate{
    @IBOutlet var collectionView: UICollectionView!
    
    var contents:[BBSContentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = WaterFlowLayout()
        layout.waterFlowDelegate = self
        layout.numberOfColumns = 2
        layout.interItemSpacing = 5
        collectionView.collectionViewLayout = layout
        
        self.contents = TestData.instance.bbsData()

    }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_bbs_list", forIndexPath: indexPath) as CellBBSList
        let datarow = self.contents[indexPath.row]
        
        let username = TestData.instance.userNameList[datarow.userid]
        var userface = "user" + String(datarow.userid) + ".jpg"
        
        cell.configureWithContents(username, userface: userface, imageUrl: datarow.imagePath, contents: datarow.text)
        
        return cell
    }
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        
        self.performSegueWithIdentifier("bbs_detail",sender: "掲示板ー詳細")
        
        return true
    }
    
    
    //MARK: - CWWaterFlowLayout Delegate
    
    func heightForRowInCollectionView(collectionView: UICollectionView, usingLayout layout: WaterFlowLayout, atIndexPath indexPath: NSIndexPath) -> Float {
        return Float(50 + arc4random() % 100) + 44 + 20
    }
}