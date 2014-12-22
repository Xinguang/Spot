//
//  EventController.swift
//  spot
//
//  Created by Hikaru on 2014/12/04.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//


import UIKit
import MapKit

class EventController: CommonController,MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var mapview: MKMapView!
    @IBOutlet var tableView: UITableView!
    var msgRow: [MessageRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapview.showsUserLocation = true;
        self.mapview.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth;
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        var b = UIBarButtonItem(title: "チャット", style: .Plain, target: self, action: Selector("openMessage:"))
        self.navigationItem.rightBarButtonItem = b
        
        self.msgRow = TestData.instance.tableViewData("メンバー",subtitle: "メンバー")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    ////////////////map     //////////////////////////
    //////////////////////////////////////////////////
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(mapview.userLocation.classForCoder){
            return nil;
        }
        
        let pinView = MKAnnotationView(annotation:annotation,reuseIdentifier:"ID");

        
        pinView.image = UIImage(named: "mapPin_001")!
        
        pinView.canShowCallout = true;
        return pinView;
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        self.search();
    }
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        performSegueWithIdentifier("contacts_person",sender: "map")
    }
    
    func search(){
        self.mapview.removeAnnotations(self.mapview.annotations);
        //pin
        let mappins = TestData.instance.getMapPoints();
        self.mapview.addAnnotations(mappins)
        
        let region = MKCoordinateRegionMakeWithDistance(mappins[0].coordinate, 500, 500)
        self.mapview.setRegion(region, animated: true)
        
    }
    
    //////////////////////////////////////////////////
    //////////////////////////////////////////////////
    ////////////////tableview     ////////////////////
    //////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "メンバー"
    }
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.imageView?.image = datarow.image
        cell.titleLable.text = datarow.title
        return cell
        /*
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as UITableViewCell;//MessageCell;
        cell.textLabel.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))";
        //cell.titleLable.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))"
        return cell
        */
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("contacts_person",sender: self.msgRow[indexPath.row].title)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }

}