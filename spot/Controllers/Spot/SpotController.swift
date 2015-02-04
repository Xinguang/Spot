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
        var pincolor:UInt = 0xFF00FF;
        switch self.selectedSegmentIndex
        {
        case 0:
            pincolor = 0xFF00FF;
            break;
        case 1:
            pincolor = 0x00FFFF;
            break;
        case 2:
            pincolor = 0xFFFF00;
            break;
        default:
            pincolor = 0xFF00FF;
            break;
        }
        
        let img = UIImage(named: "mappin")!
        let image = CommonHelper.instance.coloredImage(img, color: CommonHelper.instance.UIColorFromRGB(pincolor, alpha: 0.5))//0.1~1
        pinView.image = image//UIImage(named: imageName)!
        //self.anime(pinView, isplus: true)
        pinView.canShowCallout = true;
        return pinView;
    }
    func anime(obj:UIView,isplus:Bool){
        var size:CGSize;
        if (isplus){
            size = CGSizeMake(obj.frame.size.width - 5 , obj.frame.size.height - 5)
        }else{
            size = CGSizeMake(obj.frame.size.width + 5 , obj.frame.size.height + 5)
        }
        obj.layer.runAnimation(Animation.resizeFrame(size, delay: 1), blockCompletion: { () -> () in
            self.anime(obj, isplus: !isplus)
        })
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
        
        //0.01~0.1
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02);
        
        let region = MKCoordinateRegionMake(defaultPoint,span)
        //let region = MKCoordinateRegionMakeWithDistance(defaultPoint, 0, 0)
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