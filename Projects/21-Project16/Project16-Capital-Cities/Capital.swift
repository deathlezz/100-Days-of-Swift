//
//  Capital.swift
//  Project16-Capital-Cities
//
//  Created by deathlezz on 07/09/2022.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var url: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, url: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.url = url
    }
}
