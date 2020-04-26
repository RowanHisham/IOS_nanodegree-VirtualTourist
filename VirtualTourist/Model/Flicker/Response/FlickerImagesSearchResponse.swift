//
//  FlickerImagesSearchResponse.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/26/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation

struct FlickerImagesSearchResponse: Codable {
    let photos: FlickerPhotosData?
    let stat: String
}

struct FlickerPhotosData: Codable{
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [FlickerPhotoData]
}

struct FlickerPhotoData: Codable{
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
}
