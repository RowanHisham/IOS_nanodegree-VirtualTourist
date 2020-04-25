//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/25/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var dataController: DataController!
    
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "pins")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func setupGestureRecognition() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        setupMap()
        setupGestureRecognition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = touchMapCoordinate
        let newPin = Pin(context: dataController.viewContext)
        newPin.latitude = newAnnotation.coordinate.latitude
        newPin.longitude = newAnnotation.coordinate.longitude
        newPin.creationDate = Date()
        print("New pin Date")
        print(newPin.creationDate)

        
        do{
            print("Before Saving")
            print(fetchedResultsController.fetchedObjects?.count ?? "")

            for pin in fetchedResultsController.fetchedObjects!{
                print(pin.creationDate)
            }

            try? dataController.viewContext.save()
            print("Saved")
            try fetchedResultsController.performFetch()
            print(fetchedResultsController.fetchedObjects?.count ?? "")

            for pin in fetchedResultsController.fetchedObjects!{
                print(pin.creationDate)
            }

        }catch{
            print("Didtn't save")
        }
        
        mapView.addAnnotation(newAnnotation)
    }
}
