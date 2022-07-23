//
//  ViewController.swift
//  12-Milestone-Projects7-9
//
//  Created by deathlezz on 19/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var wordLabel: UILabel!
    var buttonsView: UIView!
    
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var letterButtons = [UIButton]()
    
    var currentWord: String = "SILKWORM" {
        didSet {
            wordLabel.text = currentWord
        }
    }
    
    var allWorlds = [String]()
    var usedLetters = [String]()
    
    var wrongAnswers = 0
    var score = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        title = "Hangman"
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "hangman0")
        view.addSubview(imageView)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = currentWord
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.init(name: "BRADLEY HAND", size: 30)
        view.addSubview(wordLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.sizeToFit()
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: wordLabel.topAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            wordLabel.heightAnchor.constraint(equalToConstant: 40),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.heightAnchor.constraint(equalToConstant: 390),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
        ])

        wordLabel.backgroundColor = .red
        buttonsView.backgroundColor = .gray
        
        let width = 50
        let height = 75
        
        var firstColumn = 0
        var lastColumn = 7
        var index = 0
        
        for row in 0..<4 {
            for column in firstColumn..<lastColumn {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.init(name: "BRADLEY HAND", size: 35)
                letterButton.setTitle(letters[index], for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.backgroundColor = .green

                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                index += 1
            }
            
            if index > 20 {
                lastColumn = 6
                firstColumn = 1
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startGame()
        
    }
    
    func startGame() {
        if let wordsURL = Bundle.main.url(forResource: "english", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                allWorlds = words.components(separatedBy: "\n")
            }
        }
        
        if allWorlds.isEmpty {
            allWorlds.append("silkworm")
        }
        
        currentWord = allWorlds.randomElement()!.uppercased()
        
        let hiddenWord = String(repeating: "?", count: currentWord.count)
        wordLabel.text = hiddenWord
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        var wordText = ""
        
        if currentWord.contains(buttonTitle) {
            for letter in currentWord {
                let stringLetter = String(letter)
                
                if stringLetter == buttonTitle {
                    wordText += "\(stringLetter) "
                } else {
                    wordText += "_ "
                }
            }
        }
        wordLabel.text = wordText.trimmingCharacters(in: .whitespaces)
    }
}

