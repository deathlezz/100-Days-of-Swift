//
//  Person.swift
//  Project10-Names-to-Faces
//
//  Created by deathlezz on 01/08/2022.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
