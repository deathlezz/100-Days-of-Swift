//
//  Country.swift
//  Milestone-Projects13-15
//
//  Created by deathlezz on 02/09/2022.
//

import Foundation

struct Country: Codable {
    let name: String
    let flag: String
    let population: Int
    let subregion: String
    let capital: String?
    let currencies: [Currency]?
    let languages: [Language]
}

struct Currency: Codable {
    let code: String
}

struct Language: Codable {
    let name: String
}
