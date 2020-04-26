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
    
    func configureUI(){
        let space:CGFloat = 2.0
        let dimensionW = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionH = (view.frame.size.height - (2 * space)) / 6.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionW, height: dimensionH)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        let newCollectionBarButtonItem = UIBarButtonItem(title: "New Collection", style: .done, target: self, action: #selector(getNewCollection))
        let spaceItemLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let spaceItemRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        
        self.setToolbarItems([spaceItemLeft, newCollectionBarButtonItem, spaceItemRight], animated: false)
    }
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Deleting")

        deleteImage(image: fetchedResultsController.object(at: indexPath))
        images.remove(at: indexPath.row)
        collectionView.reloadData()
    }
    
    @objc func getNewCollection(){
        for image in images{
            delete(image)
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
