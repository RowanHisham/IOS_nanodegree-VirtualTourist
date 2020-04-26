//
//  CollectionCollectionViewController.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ImagesCollectionViewCell"

class CollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var dataController: DataController!
    
    var pinAnnotation: CustomPinAnnotation!

    var fetchedResultsController:NSFetchedResultsController<Image>!
    

    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "pin == %@", pinAnnotation.pin)
        fetchRequest.predicate = predicate
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func loadFLickerImages() {
        print("LOADING Images")
            FlickerCLient.getPhotosSearch(latitude: pinAnnotation.pin.latitude, longitude:  pinAnnotation.pin.longitude, completion: handleFlickerImagesSearchResponse)
    }
    
    func checkImagesCount(){
        if (fetchedResultsController.fetchedObjects?.count == 0){
            loadFLickerImages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFetchedResultsController()
        checkImagesCount()
    }

    func handleFlickerImagesSearchResponse(response: FlickerImagesSearchResponse?, error: Error?){
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("Adding Cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagesCollectionViewCell
    
        // Configure the cell
        if let data = fetchedResultsController.object(at: indexPath).image{
            cell.imageView?.image = UIImage(data: data)
        }
        
        return cell
    }
}
