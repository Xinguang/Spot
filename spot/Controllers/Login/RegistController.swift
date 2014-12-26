//
//  RegistController.swift
//  spot
//
//  Created by Hikaru on 2014/12/12.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class RegistController:CommonController{
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnLogout: UIButton!

    var msgRow: [CellRow] = []
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        // Initialization code
        if(nil != icon){
            
            icon.layer.cornerRadius = self.icon.bounds.size.height/2
            icon.layer.masksToBounds = true;
            
            icon.layer.borderWidth = 3
            icon.layer.shadowOpacity = 0.5;
            icon.layer.borderColor = UIColor.whiteColor().CGColor
        }

        if  nil != self.paramData {
            self.btnBack.hidden = false;
            self.btnNext.hidden = false;
            self.btnLogout.hidden = true;
            if let param = self.paramData as? Dictionary<String, AnyObject> {
                SettingHelper.instance.setList(param, prefix: "sys_")
                //CommonHelper.instance.setImageFromUrl(self.icon, uri: param["figure"] as String)
                CommonHelper.instance.setImageFromUrl(self.icon, uri: param["figure"] as String, callback: { (imgData) -> () in
                    SettingHelper.instance.set("sys_figure_data", value: imgData)
                })
                self.msgRow = [
                    CellRow(image: UIImage(named: "icon_qq")!,title: "ニックネーム",subtitle: param["nickname"] as String),
                    CellRow(image: UIImage(named: "icon_qq")!,title: "生年月日",subtitle: param["birthday"] as String),
                    CellRow(image: UIImage(named: "icon_qq")!,title: "性別",subtitle: param["sex"] as String),
                    CellRow(image: UIImage(named: "icon_qq")!,title: "現場",subtitle: "三田"),
                ];
            }
        }else{
            self.btnNext.hidden = true;
            self.btnBack.hidden = true;
            self.btnLogout.hidden = false;
            self.msgRow = [
                CellRow(image: UIImage(named: "icon_qq")!,title: "ニックネーム",subtitle: SettingHelper.instance.get("sys_nickname") as String),
                CellRow(image: UIImage(named: "icon_qq")!,title: "生年月日",subtitle: SettingHelper.instance.get("sys_birthday")  as String),
                CellRow(image: UIImage(named: "icon_qq")!,title: "性別",subtitle: SettingHelper.instance.get("sys_sex")  as String),
                CellRow(image: UIImage(named: "icon_qq")!,title: "現場",subtitle: "三田"),
            ];
            
            if let imageData = SettingHelper.instance.get("sys_figure_data") as? NSData{
                self.icon.image = UIImage(data: imageData)
            }
        }
        /*
        var flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.scrollDirection = scrollDirection
        self.collectionView.collectionViewLayout = flowLayout
        */
        /////////////////////////////
        //self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    
    
    @IBAction func unwindToSegue(segue : UIStoryboardSegue) {
        
    }
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    ////////////////tableview     ////////////////////
    //////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本情報"
    }
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let datarow = self.msgRow[indexPath.row];
        
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        cell.titleLable.text = datarow.title
        cell.subTitleLable.text = datarow.subtitle
        /*
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = datarow.title
        cell.detailTextLabel?.text = datarow.subtitle
        */
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    ////////////////collectionView     ////////////////////
    //////////////////////////////////////////////////
    
    // #pragma mark UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView?, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 6
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell_tag", forIndexPath: indexPath) as CellTag
        //cell.backgroundView = UIImageView(image: UIImage(named: "weather.png"))
        // Configure the cell
        if(indexPath.row==5){
            cell.titleLabel.text = "+"
            cell.checked(false)
        }else{
            cell.titleLabel.text = "tag" + String(indexPath.row)
            cell.checked(true)
        }
        return cell
    }
    
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if(indexPath.row==5){
            performSegueWithIdentifier("show_tags",sender: "タグ一覧")
            return false
        }else{
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as CellTag
            cell.checked( !cell.IsCheckeded )
            println("selected")
            return true
        }
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
       return CGSizeMake(90, 60)
    }
    
    @IBAction func unwindForTags (segue : UIStoryboardSegue) {
        
    }
}