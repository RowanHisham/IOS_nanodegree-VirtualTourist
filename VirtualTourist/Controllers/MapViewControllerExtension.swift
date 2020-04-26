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
    
    // -------------------------------------------------------------------------
    // MARK: -Map Setup
    
    // Extract the information for every pin and update annotation list
    func setupMap(){
        var annotations = [CustomPinAnnotation]()
        
        //Extract info from pins list
        for pin in fetchedResultsController!.fetchedObjects! {
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            //create the annotation and set its coordiate, title, and subtitle properties
            let annotation = CustomPinAnnotation(coordinate: coordinate, pin: pin)

            // append the annotation in an array of annotations
            annotations.append(annotation)
        }
        
        // add the annotations to the map
        self.mapView.addAnnotations(annotations)
        self.mapView.reloadInputViews()
    }
    
    
    // Update and Display PinMarker
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
    
    // -------------------------------------------------------------------------
    // MARK: - Navigation
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
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
