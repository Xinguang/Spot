//
//  SettingController.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class SettingController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,SpotTableViewDelegate{
    
    var msgRow: [CellRow] = []
    var user:UserModel?
    var delegate:SpotTableViewDelegate?
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var img:UIImage = UIImage(named: "background")!
        //self.tableView.backgroundColor = UIColor(patternImage: img);
        
        self.msgRow = [
            CellRow(image: UIImage(named: "icon_qq")!,title: "氏名",subtitle: "ID　XXXXXXXX"),
            CellRow(image: UIImage(named: "icon_qq")!,title: "お気に入り",subtitle: "イベントからからのメッセージ"),
            CellRow(image: UIImage(named: "icon_qq")!,title: "携帯",subtitle: "00000000000"),
            CellRow(image: UIImage(named: "icon_qq")!,title: "WeiChat",subtitle: "xxxxxxxx"),
            CellRow(image: UIImage(named: "icon_qq")!,title: "QQ",subtitle: "88888888"),
        ];
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    //Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
    return 1;
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "sectionRow  \(section)"
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30;
    }
    */
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.accessoryView = nil
        cell.imageView?.image = nil
        switch indexPath.row {
        case 0:
            if let imageData = SettingHelper.instance.get("sys_figure_data") as? NSData{
                cell.imageView?.image = UIImage(data: imageData)
            }else{
                cell.imageView?.image = datarow.image;
            }
        case 2,3,4:
            let switchview = UISwitch(frame: CGRectZero)
            cell.accessoryView = switchview;
            cell.imageView?.image = nil
        default:
            cell.imageView?.image = nil
        }
        
        
        cell.titleLable.text = datarow.title
        cell.subTitleLable.text = datarow.subtitle
        return cell
        /*
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as UITableViewCell;//MessageCell;
        cell.textLabel.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))";
        //cell.titleLable.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))"
        return cell
        */
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.onSelect(tableView, didSelectRowAtIndexPath: indexPath, didSelectRowData: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 100;
        default:
            return 50;
        }
    }
    /*
    - (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
    NSString *versionNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //NSString *buildNum = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"バージョン情報　Ver %@", versionNum ];
    }
    
    return nil;
    }
    */
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var res = ""
        if(section == 0 ){
            if let info = NSBundle.mainBundle().infoDictionary as Dictionary<NSObject,AnyObject>? {
                if let versionNum = info["CFBundleShortVersionString"] as? String {
                    res = NSString(format: "バージョン情報　Ver %@", versionNum)
                    if let buildNum = info["CFBundleVersion"] as? String{
                        res = NSString(format: "%@.%@", res,buildNum)
                    }
                }
            }
        }
        return res
    }
    //test_fav
    
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
    //////
    func onSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath,didSelectRowData data:AnyObject?){
        if(indexPath.row == 0){
            performSegueWithIdentifier("setting_pofile",sender: "設定")
        }
    }
    
}
