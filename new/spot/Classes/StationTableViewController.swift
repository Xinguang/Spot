//
//  StationTableViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class StationTableViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var stations = [PFObject]()
    var stationAddVC: StationAddTableViewController?
    var selectedStations = [PFObject]()
    
    let user = XMPPManager.instance.account
    
    var changed = false
    var finishedLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()


        SVProgressHUD.showWithMaskType(.Clear)
        
        ParseController.getStations { (res, error) -> Void in
            self.finishedLoading = true

            if let error = error {
                SVProgressHUD.showErrorWithStatus(error.localizedDescription, maskType: .Clear)
            }
            
            if let res = res {
                //save to local?
                
                
                self.stations = res

                for stationObj in res {
                    if UserController.isStationOfUser(stationObj, user: self.user) {
                        self.selectedStations.append(stationObj)
                    }
                }


                self.tableView.reloadData()
            }
            
            SVProgressHUD.dismiss()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let newStationName = stationAddVC?.newStationName {
            changed = true

            let newStation = PFObject(className: "Station")

            newStation!["name"] = newStationName

            // TODO: lat lon

            stations.append(newStation)
            selectedStations.append(newStation)

            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if changed {
            ParseController.saveStations(selectedStations, user: user)
            UserController.saveStations(selectedStations, user: user)
            UserController.saveUser(user)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueAddStation" {
            stationAddVC = segue.destinationViewController as? StationAddTableViewController
        }
    }
}

// MARK: - UITableView

extension StationTableViewController: UITableViewDataSource, UITableViewDelegate {
  
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return stations.count
        }
        
        return finishedLoading ? 1 : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let stationObj = stations[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = stationObj["name"] as? String
        
            if find(selectedStations, stationObj) != nil {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AddCell", forIndexPath: indexPath) as UITableViewCell
                
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            let stationObj = stations[indexPath.row] as PFObject
            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
            
            changed = true
            
            if find(selectedStations, stationObj) != nil {
                selectedStations.remove(stationObj)
                
                if let cell = cell {
                    cell.accessoryType = .None
                }
            } else {
                selectedStations.append(stationObj)
                
                if let cell = cell {
                    cell.accessoryType = .Checkmark
                }
            }
        }
    }
}
