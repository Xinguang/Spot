//
//  EventListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/04.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class EventListController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,AngleViewDelegate{
    
    var msgRow: [MessageRow] = []
    var _menu:REMenu = REMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var img:UIImage = UIImage(named: "background")!
        self.tableView.backgroundColor = UIColor(patternImage: img);
      /*
        let start = UIImage(named: "+")
        let image1 = UIImage(named: "icon_qq")
        let image2 = UIImage(named: "icon_qq")
        let image3 = UIImage(named: "icon_qq")
        var images:[UIImage] = [image1!,image2!,image3!]
        var menu = AngleView(view:self.view,startPoint: CGPointMake(self.view.frame.size.width-50, 10), startImage: start!, submenuImages:images,startAngle:180)
        menu.delegate = self
        
        var b = UIBarButtonItem(customView:menu);
        //var b = UIBarButtonItem(title: "作成", style: .Plain, target: self, action: Selector("createEventMap:"))
        self.navigationItem.rightBarButtonItem = b
        
        func createEventMap(sender :UIButton){
        //performSegueWithIdentifier("event_create",sender: "イベントを作成")
        }
        */
        self.msgRow = TestData.instance.tableViewData("イベント",subtitle: "メンバー")
        
        
        
        //"参加", "★", "投稿", "チャット"
        self._menu = REMenu(items: [
            CustomRemenuItem(title: "作成",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                self.performSegueWithIdentifier("event_create",sender: "イベントを作成")
            }),
            ])
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: Selector("toggleMenu"))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleMenu()
    {
        if (self._menu.isOpen){
            return self._menu.close()
        }
        //self._menu.showFromNavigationController(self.navigationController)
        self._menu.showFromRect(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), inView: self.view)
        //self._menu.showInView(self.view)
    }
    
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        cell.icon.image = self.msgRow[indexPath.row].image
        cell.titleLable.text = self.msgRow[indexPath.row].title
        cell.subTitleLable.text = self.msgRow[indexPath.row].subtitle
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view: UIViewController = segue.destinationViewController as UIViewController
        if let cell = sender as? MessageCell {
            view.title = cell.titleLable.text
        } else if let text = sender as? NSString {
            view.title = text
        }else{
            view.title = "詳細"
        }
        view.hidesBottomBarWhenPushed = true
        
    }
    
    //search bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true;
        return true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false;
    }
    
    
    
    func subButtonDidSelected(index: Int) {
        println("\(index)")
    }
    
}