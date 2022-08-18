//
//  Picture.swift
//  16-Milestone-Projects10-12
//
//  Created by deathlezz on 17/08/2022.
//

import UIKit

class Picture: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
