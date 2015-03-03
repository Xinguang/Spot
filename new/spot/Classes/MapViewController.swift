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
    
    var didGetUserLocation = false
    
    var gpsModel: GPSModel!
    var polygon: MKPolygon!
    var annotations: [UserAnnotation]!
    
    enum ShowType {
        case Polygon
        case Point
    }
    
    var showType = ShowType.Polygon
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lm.delegate = self
        lm.requestWhenInUseAuthorization()
        lm.startUpdatingLocation()
        
        gpsModel = MapDataConroller.stationUsers()
        
        addModelToMapView()
    }

    func addModelToMapView() {
        if showType == .Polygon {
            if polygon == nil {
            var coors = [CLLocationCoordinate2D]()
            
            gpsModel.positions.each { (i, position) -> () in
                let coor = CLLocationCoordinate2D(latitude: position.lat, longitude: position.lon)
                coors.append(coor)
            }
            
            polygon = MKPolygon(coordinates: &coors, count: coors.count)
            }
            mapView.addOverlay(polygon)
        }

        if showType == .Point {
            if annotations == nil {
                annotations = [UserAnnotation]()
                
                gpsModel.positions.each { (i, position) -> () in
                    let anno = UserAnnotation(model: position as PositionModel)
                    self.annotations.append(anno)
                }
            }
            
            mapView.addAnnotations(annotations)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func centerToLocation(location: CLLocation) {
        //0.01~0.1
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02);

        let region = MKCoordinateRegionMake(location.coordinate, span)

        mapView.setRegion(region, animated: true)
    }

    // MARK: - Action
    
    @IBAction func debug(sender: AnyObject) {
        mapView.removeAnnotations(annotations)
        mapView.removeOverlay(polygon)

        if showType == .Polygon {
            showType = .Point
        } else {
            showType = .Polygon
        }
        
        addModelToMapView()
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        let polygon = overlay as MKPolygon
        
        let render = MKPolygonRenderer(overlay: overlay)
        
        render.fillColor = UIColor(hexString: "#4AE664")
        render.strokeColor = UIColor(hexString: "#4AE664")
        render.lineWidth = 5
        return render
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinView = MKAnnotationView(annotation:annotation,reuseIdentifier:"ID");
        let img = UIImage(named: "userPin")
//        var pincolor:UInt = 0xFF00FF;
//        switch segmentedControl.selectedSegmentIndex
//        {
//        case 0:
//            pincolor = 0xFF00FF;
//        case 1:
//            pincolor = 0x00FFFF;
//        case 2:
//            pincolor = 0xFFFF00;
//        default:
//            pincolor = 0xFF00FF;
//        }
        
//        let img = UIImage(named: "mappin")!
//        let image = CommonHelper.instance.coloredImage(img, color: CommonHelper.instance.UIColorFromRGB(pincolor, alpha: 0.1))
//        pinView.image = image//UIImage(named: imageName)!
        pinView.image = img
        pinView.canShowCallout = true;
        return pinView; 
    }
    
//    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
//        
//    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let l = locations.last as? CLLocation {
            if !didGetUserLocation {
                didGetUserLocation = true
                centerToLocation(l)
            }
        }

//        let location = locations.last as CLLocation
//        
//        //0.01~0.1
//        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02);
//        
//        let region = MKCoordinateRegionMake(location.coordinate, span)
//
//        mapView.setRegion(region, animated: true)
    }
}
