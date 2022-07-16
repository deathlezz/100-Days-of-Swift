//
//  Petition.swift
//  Project7-Whitehouse-Petitions
//
//  Created by deathlezz on 10/07/2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
