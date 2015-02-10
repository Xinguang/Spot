//
//  MapViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let lm = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func debug(sender: AnyObject) {
//        User.addFriend("")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
