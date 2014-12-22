//
//  SpotController.swift
//  spot
//
//  Created by Hikaru on 2014/12/04.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//


import UIKit
import MapKit

class SpotController: CommonController,MKMapViewDelegate{
    
    @IBOutlet var mapview: MKMapView!
    
    var imageName:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapview.showsUserLocation = true;
        
        
        
        self.search()
        //self.mapview.mapType = MKMapType.Standard;//默认
        //self.mapview.mapType = MKMapType.Satellite;//卫星
        //self.mapview.mapType = MKMapType.Hybrid; //混合
        self.view.addSubview(self.mapview);
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
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
        if("" == imageName){
            imageName = "mapPin_001"
        }
        
        pinView.image = UIImage(named: imageName)!
        
        pinView.canShowCallout = true;
        return pinView;
    }
    /*
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let defaultPoint =  CLLocation(latitude: 35.64818,longitude: 139.748775).coordinate//三田
        
        let region = MKCoordinateRegionMakeWithDistance(defaultPoint, 250, 250)
        self.mapview.setRegion(region, animated: true)
    }
    */
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var identifier = "";
        switch imageName
        {
        case "group":
            identifier = "contacts_group"
        case "mapqq":
            identifier = "contacts_weixinqq"
        case "bbs":
            identifier = "contacts_bbs"
        case "mapPin_001":
            identifier = "contacts_event"
        default:
            identifier = "contacts_group"
        }
        
        performSegueWithIdentifier(identifier,sender: "map")
    }
    
    func search(){
        self.mapview.removeAnnotations(self.mapview.annotations);
        //pin
        
        //pin
        let mappins = TestData.instance.getMapPoints();
        
        self.mapview.addAnnotations(mappins)
        
        let region = MKCoordinateRegionMakeWithDistance(self.mapview.userLocation.coordinate, 2500, 2500)
        self.mapview.setRegion(region, animated: true)
        
        
        /*
        
        let request = MKLocalSearchRequest();
        request.naturalLanguageQuery = "東京"
        request.region = self.mapview.region;
        
        let search = MKLocalSearch(request: request);
        
        
        search.startWithCompletionHandler { (response:MKLocalSearchResponse!, error:NSError!) -> Void in
        if nil != error {
        var placemarks:[MapPoint] = [
        MapPoint(coordinate: CLLocation(latitude: 35.6498169,longitude: 139.7567007).coordinate,title: "title1",subtitle: "subtitle"),
        MapPoint(coordinate: CLLocation(latitude: 35.6499169,longitude: 139.7577007).coordinate,title: "title2",subtitle: "subtitle"),
        MapPoint(coordinate: CLLocation(latitude: 35.6488169,longitude: 139.7587007).coordinate,title: "title3",subtitle: "subtitle"),
        MapPoint(coordinate: CLLocation(latitude: 35.6497169,longitude: 139.7597007).coordinate,title: "title4",subtitle: "subtitle"),
        MapPoint(coordinate: CLLocation(latitude: 35.6478169,longitude: 139.7570077).coordinate,title: "title5",subtitle: "subtitle"),
        ];
        for item in response.mapItems {
        let mark = item as MKMapItem
        placemarks.append(
        MapPoint(coordinate: mark.placemark.coordinate,title: mark.placemark.title,subtitle: mark.placemark.subtitle)
        )
        }
        //self.mapview.removeAnnotations(self.mapview.annotations)
        
        self.mapview.addAnnotations(placemarks)
        
        let region = MKCoordinateRegionMakeWithDistance(placemarks[0].coordinate, 250, 250)
        self.mapview.setRegion(region, animated: true)
        
        
        //self.mapview.showAnnotations(placemarks, animated: true)
        }else{
        NSLog("error")
        }
        }
        */
    }

    @IBAction func itemOnClick(sender: AnyObject) {
        let item = sender as UISegmentedControl
        
        switch item.selectedSegmentIndex
        {
        case 0:
            imageName = "mapPin_001"
        case 1:
            imageName = "bbs"
        case 2:
            imageName = "mapqq"
        case 3:
            imageName = "group"
        default:
            imageName = "mapPin_001"
        }
        self.search()
    }
    
}