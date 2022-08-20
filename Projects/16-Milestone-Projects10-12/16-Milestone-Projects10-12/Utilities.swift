//
//  Utilities.swift
//  16-Milestone-Projects10-12
//
//  Created by deathlezz on 20/08/2022.
//

import Foundation

class Utilities {
    
    static func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    static func savePicture(_ pictures: [Picture]) {
        let jsonEncoder = JSONEncoder()
        
        if let savedPictures = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedPictures, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }
    
    static func loadPicture() -> [Picture] {
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            if let decodedPictures = try? jsonDecoder.decode([Picture].self, from: savedPictures) {
                return decodedPictures
            } else {
                print("Failed to load pictures.")
            }
        }
        
        return [Picture]()
    }
    
}
