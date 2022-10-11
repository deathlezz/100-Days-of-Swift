//
//  main.swift
//  Project24-Swift-Strings
//
//  Created by deathlezz on 09/10/2022.
//

import Foundation

// example 1

//let name = "Taylor"
//
//for letter in name {
//    print("Give ma a \(letter)!")
//}
//
//let letter = name[name.index(name.startIndex, offsetBy: 3)]
//print(letter)
//
//extension String {
//    subscript(i: Int) -> String {
//        return String(self[index(startIndex, offsetBy: i)])
//    }
//}
//
//let letter2 = name[3]
//print(letter2)

// example 2

//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//
//    func deletingSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}
//
//let password = "12345"
//print(password.hasPrefix("123"))
//print(password.hasSuffix("456"))


// example 3

//let weather = "It's going to rain"
//print(weather.capitalized)
//
//extension String {
//    var capitalizedFirst: String {
//        guard let firstLetter = self.first else { return "" }
//        return firstLetter.uppercased() + self.dropFirst()
//    }
//}

// example 4

//let input = "Swift is like Objective-C without the C"
//print(input.contains("Swift"))
//
//let languages = ["Python", "Ruby", "Swift"]
//print(languages.contains("Swift"))
//
//extension String {
//    func containsAny(of array: [String]) -> Bool {
//        for item in array {
//            if self.contains(item) {
//                return true
//            }
//        }
//        return false
//    }
//}
//
//print(input.containsAny(of: languages))
//
//print(languages.contains(where: input.contains))

// Challenge 1
extension String {
    func withPrefix(_ prefix: String) -> String {
        guard !self.contains(prefix) else { return self }
        return prefix + self
    }
}

assert("ger".withPrefix("bur") == "burger")
assert("pet".withPrefix("car") == "carpet")

// Challenge 2
extension String {
    var isNumeric: Bool {
        return self.rangeOfCharacter(from: .decimalDigits) != nil
    }
}

assert("burger".isNumeric == false)
assert("123".isNumeric == true)
assert("ab123cv".isNumeric == true)

// Challenge 3
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

assert("this\nis\na\ntest".lines == ["this", "is", "a", "test"])
