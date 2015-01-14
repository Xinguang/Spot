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
    
    // 0 付近
    // 1 友人
    // 2 掲示板
    var selectedSegmentIndex:Int = 0;
    
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
        var imageName = "mapqq";
        switch self.selectedSegmentIndex
        {
        case 0:
            imageName = "mapqq"
            break;
        case 1:
            imageName = "mapqq"
            break;
        case 2:
            imageName = "bbs"
            break;
        default:
            imageName = "mapqq"//付近
            break;
        }
        
        pinView.image = UIImage(named: imageName)!
        
        pinView.canShowCallout = true;
        return pinView;
    }
    
    /*
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 25, 25)
        mapView.setRegion(region, animated: true)
    }
    */
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var identifier = "";
        switch self.selectedSegmentIndex
        {
        case 0:
            identifier = "contacts_weixinqq"
            break;
        case 1:
            identifier = "contacts_weixinqq"
            break;
        case 2:
            identifier = "contacts_bbs"
            break;
        default:
            identifier = "contacts_weixinqq"//付近
            break;
        }
        
        performSegueWithIdentifier(identifier,sender: "map")
    }
    
    func search(){
        self.mapview.removeAnnotations(self.mapview.annotations);
        //pin
        
        //pin
        let mappins = TestData.instance.getMapPoints();
        
        self.mapview.addAnnotations(mappins)
        
        
        let defaultPoint =  CLLocation(latitude: 35.64818,longitude: 139.748775).coordinate//三田
        
        let region = MKCoordinateRegionMakeWithDistance(defaultPoint, 0, 0)
        self.mapview.setRegion(region, animated: true)
    }

    // 0 付近
    // 1 友人
    // 2 掲示板
    @IBAction func itemOnClick(sender: AnyObject) {
        let item = sender as UISegmentedControl
        self.selectedSegmentIndex = item.selectedSegmentIndex
        self.search()
    }
    
}