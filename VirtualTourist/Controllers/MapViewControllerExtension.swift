//
//  MapViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/25/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate{
    
    // MARK: Extract the information for every student and update annotation list
    func setupMap(){
        print("setting up map")
        var annotations = [CustomPinAnnotation]()
        
        //TODO: Extract info from pins list
        
        for pin in fetchedResultsController!.fetchedObjects! {
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            //create the annotation and set its coordiate, title, and subtitle properties
            let annotation = CustomPinAnnotation(coordinate: coordinate, pin: pin)

            // append the annotation in an array of annotations.
            annotations.append(annotation)
            print(annotation.pin.creationDate)
        }
        
        // add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        self.mapView.reloadInputViews()
    }
    
    
    // MARK: Update and Display PinMarker
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
        print("Pin Clicked")
        let pinAnnotation = view.annotation as! CustomPinAnnotation
        performSegue(withIdentifier: "CollectionViewSegue", sender: pinAnnotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionViewSegue"{
            let collectionView = segue.destination as! CollectionViewController
            let pinAnnotation = sender as! CustomPinAnnotation
            collectionView.pin = pinAnnotation.pin
            collectionView.dataController = dataController
        }
    }
}
