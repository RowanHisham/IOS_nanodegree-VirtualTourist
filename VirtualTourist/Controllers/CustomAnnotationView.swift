//
//  CustomAnnotationView.swift
//  VirtualTourist
//
//  Created by Rowan Hisham on 4/25/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import MapKit

class CustomPinAnnotation: NSObject, MKAnnotation {
    let title: String? = nil
    let subtitle: String? = nil
    let coordinate: CLLocationCoordinate2D
    var pin: Pin
    
    init(coordinate: CLLocationCoordinate2D, pin: Pin) {
        self.coordinate = coordinate
        self.pin = pin
        super.init()
    }
}
