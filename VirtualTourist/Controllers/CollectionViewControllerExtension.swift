//
//  CollectionViewControllerExtension.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension CollectionViewController{
    
    // -------------------------------------------------------------------------
    // MARK: - UI
    
    func configureUI(){
        let space:CGFloat = 2.0
        let dimensionW = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionH = (view.frame.size.height - (2 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        let newCollectionBarButtonItem = UIBarButtonItem(title: "New Collection", style: .done, target: self, action: #selector(getNewCollection))
        let spaceItemLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        
        self.setToolbarItems([spaceItemLeft, newCollectionBarButtonItem, spaceItemRight], animated: false)
    }
    
    func showActivity(_ state:Bool){
        if state {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            navigationController?.toolbar.isUserInteractionEnabled = false
            navigationController?.navigationBar.isUserInteractionEnabled = false
        }else{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            navigationController?.toolbar.isUserInteractionEnabled = true
            navigationController?.navigationBar.isUserInteractionEnabled = true
        }
    }
    
    // MARK: Display Error Message to the User
    func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // -------------------------------------------------------------------------
    // MARK: - CollectionView
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        
        // Configure the cell
        if let data = images[indexPath.row].image{
            cell.imageView?.image = UIImage(data: data)
        }
        return cell
    }
    
    // Delete Image on tap
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteImage(image: fetchedResultsController.object(at: indexPath))
        images.remove(at: indexPath.row)
        collectionView.reloadData()
    }

    
    // -------------------------------------------------------------------------
    // MARK: - New Collection
    
    @objc func getNewCollection(){
        for image in images{
            deleteImage(image: image)
        }
        images = []
        collectionView.reloadData()
        loadFLickerImages()
    }
    
    func deleteImage(image: Image){
        dataController.viewContext.delete(image)
        try? dataController.viewContext.save()
    }
}
