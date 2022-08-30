//
//  ViewController.swift
//  Project15-Debugging
//
//  Created by deathlezz on 30/08/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing!")
    }

    func myReallySlowMethod() -> Bool {
        return false
    }

}

