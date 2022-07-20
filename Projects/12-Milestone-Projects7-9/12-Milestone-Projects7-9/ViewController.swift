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
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var letterButtons = [UIButton]()
    
    var currentWord = "silkworm"
    var allWorlds = [String]()
    var usedLetters = [String]()
    var wrongAnswers = 0
    var score = 0
    
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
        currentWord = allWorlds.randomElement()!
        wordLabel.text = String(repeating: "_ ", count: currentWord.count).trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        addButtonsToRow(position: 0, columns: 6, view: row1)
        addButtonsToRow(position: 6, columns: 7, view: row2)
        addButtonsToRow(position: 13, columns: 6, view: row3)
        addButtonsToRow(position: 19, columns: 7, view: row4)
                
    }
    
    func addButtonsToRow(position: Int, columns: Int, view: UIView) {
        for column in 0..<columns {
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            letterButton.setTitle("W", for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            letterButton.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(letterButton)
            letterButtons.append(letterButton)
        }
    }
    
    @objc func letterTapped() {
        
    }
}

