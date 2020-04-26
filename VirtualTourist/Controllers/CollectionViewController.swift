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
    
    var dataController: DataController!
    var pin: Pin!
    var fetchedResultsController:NSFetchedResultsController<Image>!
    var images: [Image] = []
    
    
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
    
    
    func setupCells(){
        guard (fetchedResultsController.fetchedObjects?.count != 0) else{
            print("No Saved Images")
            loadFLickerImages()
            return
        }
        
        print("Showing Saved Images")
        images = fetchedResultsController.fetchedObjects!
        collectionView.reloadData()
    }
    
    func loadFLickerImages() {
        print("LOADING Images")
        FlickerCLient.getPhotosSearch(latitude: pin.latitude, longitude:  pin.longitude, completion: handleFlickerImagesSearchResponse)
    }

    func handleFlickerImagesSearchResponse(response: FlickerImagesSearchResponse?, error: Error?){
        guard error == nil , response != nil else {
            print("error")
            return
        }
        
        guard (response?.photos?.photo.count ?? 0) > 0 else {
            print("No Photos Found")
            return
        }
        
        
        print("Adding Images")
        images = []
        for photoData in (response?.photos?.photo)! {
            let image = Image(context:dataController.viewContext)
            image.image = UIImage(named: "placeholderImage")!.pngData()
            images.append(image)
            collectionView.reloadData()
            
            //TODO: LOAD DATA AND UPDATE IMAGES
            FlickerCLient.loadImage(photoData: photoData, image: image, completion: handleLoadImage)
        }
    }
    
    func handleLoadImage(image: Image, data: Data?, error: Error?){
        guard data != nil else {
            print("Can't Display Image")
            return
        }
        
        image.image = data
        image.creationDate = Date()
        image.pin = pin
        do{
            print("Saving...")
            try dataController.viewContext.save()
        }catch{
            print(error)
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
}
