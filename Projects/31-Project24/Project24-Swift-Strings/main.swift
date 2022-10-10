//
//  main.swift
//  Project24-Swift-Strings
//
//  Created by deathlezz on 09/10/2022.
//

import Foundation

let name = "Taylor"

for letter in name {
    print("Give ma a \(letter)!")
}

let letter = name[name.index(name.startIndex, offsetBy: 3)]
print(letter)

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]
print(letter2)
