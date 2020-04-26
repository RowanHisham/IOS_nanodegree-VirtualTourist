//
//  ImageCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
}
