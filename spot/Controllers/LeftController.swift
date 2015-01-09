//
//  LeftController.swift
//  spot
//
//  Created by Hikaru on 2014/11/25.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//
import UIKit

class LeftController: CommonNavigationController{
    
    var drawerController:DrawerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationBarHidden = true;
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if("left" == segue.identifier){
            if let view: SettingController = segue.destinationViewController as? SettingController{
                view.delegate = self
            }
        }else{
            super.prepareForSegue(segue, sender: sender)
        }
    }
    func onSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath,didSelectRowData data:AnyObject?){
        if(indexPath.row == 0){
            //performSegueWithIdentifier("setting_pofile",sender: "設定")
            self.drawerController?.hideSideViewController(true);
            
            if let rootView = self.drawerController?.rootViewController as? CommonTabController{
                rootView.selectedIndex = 1
                //let pofile = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("setting_pofile") as? UIViewController
                //rootView.selectedViewController?.presentViewController(pofile!, animated: true, completion: nil)
                rootView.selectedViewController?.performSegueWithIdentifier("setting_pofile",sender: "設定")
            }
        }
    }
    */
}

