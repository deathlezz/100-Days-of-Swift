//
//  ViewController.swift
//  12-Milestone-Projects7-9
//
//  Created by deathlezz on 19/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var row1: UIView!
    @IBOutlet var row2: UIView!
    @IBOutlet var row3: UIView!
    @IBOutlet var row4: UIView!
    
    var currentWord = ""
    
    var allWorlds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Hangman"
        imageView.image = UIImage(named: "hangman0")
        
        if let wordsURL = Bundle.main.url(forResource: "english", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                allWorlds = words.components(separatedBy: "\n")
            }
        }
        currentWord = allWorlds.randomElement() ?? "silkworm"
        wordLabel.text = String(repeating: "_ ", count: currentWord.count).trimmingCharacters(in: .whitespacesAndNewlines)
    }


}

