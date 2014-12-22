//
//  ContactsMapController.swift
//  spot
//
//  Created by Hikaru on 2014/12/03.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
import MapKit

class ContactsMapController: CommonController,MKMapViewDelegate{
    
    
    var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapview = MKMapView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.mapview.showsUserLocation = true;
        self.mapview.delegate = self;
        
        //pin
        let mappins = TestData.instance.getMapPoints();
        
        self.mapview.addAnnotations(mappins)
        
        
        
        //self.mapview.mapType = MKMapType.Standard;//默认
        //self.mapview.mapType = MKMapType.Satellite;//卫星
        //self.mapview.mapType = MKMapType.Hybrid; //混合
        self.view.addSubview(self.mapview);
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
        pinView.image = UIImage(named: "mapqq")!
        
        pinView.canShowCallout = true;
        return pinView;
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 2500, 2500)
        mapView.setRegion(region, animated: true)
        
        
    }
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        performSegueWithIdentifier("contacts_weixinqq",sender: "map")

    }   
    
}