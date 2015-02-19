//
//  MapViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit
//import MapKit

class MapViewController: BaseViewController, GMSMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        var target: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 34.689197, longitude: 135.502321)
        var camera: GMSCameraPosition = GMSCameraPosition(target: target, zoom: 12, bearing: 0, viewingAngle: 0)
        var mapView = GMSMapView(
            frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
        )
        mapView.myLocationEnabled = true
        mapView.camera = camera
        mapView.delegate = self
        
        var marker: GMSMarker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(34.689197, 135.502321)
        marker.title = "notice"
        marker.snippet = "japan"
        marker.map = mapView
        
        self.view.addSubview(mapView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
/*
extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView = MKAnnotationView(annotation:annotation,reuseIdentifier:"ID");
        var pincolor:UInt = 0xFF00FF;
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            pincolor = 0xFF00FF;
        case 1:
            pincolor = 0x00FFFF;
        case 2:
            pincolor = 0xFFFF00;
        default:
            pincolor = 0xFF00FF;
        }
        
        let img = UIImage(named: "mappin")!
//        let image = CommonHelper.instance.coloredImage(img, color: CommonHelper.instance.UIColorFromRGB(pincolor, alpha: 0.1))
//        pinView.image = image//UIImage(named: imageName)!
        pinView.image = img
        pinView.canShowCallout = true;
        return pinView;
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as CLLocation
        
        //0.01~0.1
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02);
        
        let region = MKCoordinateRegionMake(location.coordinate, span)

        mapView.setRegion(region, animated: true)
    }
}
*/
