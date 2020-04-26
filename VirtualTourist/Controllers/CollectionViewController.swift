//
//  CollectionCollectionViewController.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataController: DataController!
    var pin: Pin!
    var images: [Image] = []
    
    var fetchedResultsController:NSFetchedResultsController<Image>!

    //Setup Fetch Request to Retrieve Images Related to Pin
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        setupFetchedResultsController()
        setupCells()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    
    // -------------------------------------------------------------------------
    // MARK: - Flicker
    
    // Display Fetched Images, if there's no saved Images Search on Flicker
    func setupCells(){
        guard (fetchedResultsController.fetchedObjects?.count != 0) else{
            loadFLickerImages()
            return
        }
        
        showActivity(true)
        images = fetchedResultsController.fetchedObjects!
        collectionView.reloadData()
        showActivity(false)
    }
    
    // Search on Flicker with Coordiantes of the Pin
    func loadFLickerImages() {
        //TODO: START ACTIVITY
        showActivity(true)
        FlickerCLient.getPhotosSearch(latitude: pin.latitude, longitude:  pin.longitude, completion: handleFlickerImagesSearchResponse)
    }

    // Show placeholder image for the amount of found images in the search while downloading them
    func handleFlickerImagesSearchResponse(response: FlickerImagesSearchResponse?, error: Error?){
        guard error == nil , response != nil else {
            showActivity(false)
            showError(title: "Error", message: error?.localizedDescription ?? "try again later")
            return
        }
        
        guard (response?.photos?.photo.count ?? 0) > 0 else {
            showActivity(false)
            showError(title: "No Photos Found", message: "No photos found at this location, try again later")
            return
        }
        
        images = []
        for photoData in (response?.photos?.photo)! {
            let image = Image(context:dataController.viewContext)
            image.image = UIImage(named: "placeholderImage")!.pngData()
            images.append(image)
            
            //Download Image
            FlickerCLient.loadImage(photoData: photoData, image: image, completion: handleLoadImage)
        }
        collectionView.reloadData()
        showActivity(false)
    }
    
    
    // Replace placeholder image with downloaded image and save context
    func handleLoadImage(image: Image, data: Data?, error: Error?){
        guard data != nil, error == nil else {
            images.remove(at: images.firstIndex(of: image)!)
            dataController.viewContext.delete(image)
            return
        }
        
        guard images.contains(image) else{
            return
        }
        
        image.image = data
        image.creationDate = Date()
        image.pin = pin

        try? dataController.viewContext.save()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
