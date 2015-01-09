//
//  EventCreateConttroller.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
import AVFoundation

class EventCreateConttroller:CommonController,CommonTableViewDelegate ,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var viewController:CommonTableViewController?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        viewController = segue.destinationViewController as? CommonTableViewController;
        
        if( "event_create_tableview" == segue.identifier ){
            let msgRow = [
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0xF2BD5A, alpha: 0.75)), title: "イベント画像", subtitle: "2015年01月09"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0xF2BD5A, alpha: 0.75)), title: "開催時間", subtitle: "2015年01月09"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x7AEA9C, alpha: 0.75)), title: "開催場所", subtitle: "三田XXX会館"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0xE33B6D, alpha: 0.75)), title: "参加条件", subtitle: "EB社員"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x4166CC, alpha: 0.75)), title: "概要", subtitle: "イベント概要"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x41CC9E, alpha: 0.75)), title: "連絡事項", subtitle: "連絡事項"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x41CC9E, alpha: 0.75)), title: "メンバー", subtitle: "メンバーを招待する"),
            ]
            var msgData = [
                CellData(title: "", msgRows: msgRow)
            ]
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    //
    //CommonTableViewDelegate
    //
    func didLoad(view:CommonTableViewController){
        view.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: Selector("event_detail"))
    }
    
    //////////////////////////
    //////////////////////////
    func tableViewOnShow(cell: MessageCell, cellForRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow) -> UITableViewCell{
        /*
        var frame = cell.imageView?.frame
        cell.resetSubViews()
        if(1 == indexPath.row){//イベント画像
            cell.titleLable.hidden = true;
            cell.subTitleLable.hidden = true
            frame?.size.width = cell.frame.size.width - 10
        }
        cell.imageView?.bounds = frame!
        cell.imageView?.frame = frame!
        */
        return cell
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject)?{
        var identifier = "setview"
        if(6 == indexPath.row){
            identifier = "contact_person_list"
        }else if(0 == indexPath.row){
            identifier = "contact_person_list"
            self.imagePicker()
            return nil
        }
        return (identifier,dataRow.title)//点击跳转
        
    }
    
    func imagePicker(){
        
        var sheet: UIActionSheet = UIActionSheet();
        let title: String = "画像を選択する";
        sheet.title  = title;
        sheet.delegate = self;
        sheet.addButtonWithTitle("Cancel");
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            sheet.addButtonWithTitle("カメラ");
        }
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            sheet.addButtonWithTitle("写真を選択する");
        }
        // キャンセルボタンのindexを指定
        sheet.cancelButtonIndex = 0;
        
        // UIActionSheet表示
        sheet.showInView(viewController?.view);
  
    }
    func actionSheet(sheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if(0 < buttonIndex){
            var cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            if("カメラ" == sheet.buttonTitleAtIndex(buttonIndex)){
                cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
            }else{
                cameraUI.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            }
            cameraUI.allowsEditing = true
            
            self.presentViewController(cameraUI, animated: true, completion: { imageP in
                
            })

        }
        /*
        */


    }
    //pragma mark- Image

    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        var imageToSave:UIImage
        
        imageToSave = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        self.savedImage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savedImage()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.addButtonWithTitle("Awesome")
        alert.show()
    }
    
    
}