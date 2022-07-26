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
    
    var currentWord = "silkworm"
    
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
        wordLabel.font = UIFont.init(name: "BRADLEY HAND", size: 35)
        view.addSubview(wordLabel)
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        
    }
    
    @objc func startGame() {
        if let wordsURL = Bundle.main.url(forResource: "english", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                allWorlds = words.components(separatedBy: "\n")
            }
        }
        
        if allWorlds.isEmpty {
            allWorlds.append("silkworm")
        }
        
        currentWord = allWorlds.randomElement()!.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        let hiddenWord = String(repeating: "_ ", count: currentWord.count)
        wordLabel.text = hiddenWord
        
        wrongAnswers = 0
        imageView.image = UIImage(named: "hangman\(wrongAnswers)")
        usedLetters.removeAll()
        
        for button in letterButtons {
            button.isEnabled = true
        }
        print(currentWord)
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if currentWord.contains(buttonTitle) {
            var wordString = ""
            usedLetters.append(buttonTitle)
            
            for letter in currentWord {
                let stringLetter = String(letter)
                
                if usedLetters.contains(stringLetter) {
                    wordString += "\(stringLetter) "
                } else {
                    wordString += "_ "
                }
            }
            wordLabel.text = wordString.trimmingCharacters(in: .whitespaces)
            sender.isEnabled = false
            score += 1
            
            if wordLabel.text?.replacingOccurrences(of: " ", with: "") == currentWord {
                let alert = UIAlertController(title: "Congratulations!", message: "Word found \"\(currentWord)\"", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: levelUp))
                present(alert, animated: true)
            }
            
        } else {
            wrongAnswers += 1
            
            if wrongAnswers == 7 {
                let alert = UIAlertController(title: "Game Over", message: "Word to find was \"\(currentWord)\"", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGameTapped))
                present(alert, animated: true)
            }
            imageView.image = UIImage(named: "hangman\(wrongAnswers)")
        }
    }
    
    @objc func newGameTapped(_ action: UIAlertAction) {
        startGame()
        score = 0
    }
    
    @objc func levelUp(_ action: UIAlertAction) {
        startGame()
    }
    
    @objc func showScore() {
        let alert = UIAlertController(title: "Score", message: "Your score is \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

