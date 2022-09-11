//
//  ViewController.swift
//  Project18-Debugging
//
//  Created by deathlezz on 11/09/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(1, 2, 3, 4, 5, separator: "-", terminator: "")
        print("some message")
        
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing.")
    }

    func myReallySlowMethod() -> Bool {
        return false
    }

}

