//
//  ViewController.swift
//  Milestone-Projects28-30
//
//  Created by deathlezz on 11/11/2022.
//

import UIKit

class ViewController: UIViewController {
    var buttonsView: UIView!
    var buttons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var firstButton: UIButton!
    var secondButton: UIButton!
    var pairs = [String]()
    
    var isGameOver = false
    var counter = 0
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Pairs"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameTapped))
        
        DispatchQueue.global().async { [weak self] in
            self?.loadPairs()
        }
    }
    
    func createButtons() {
        pairs.shuffle()
        
        let width = (buttonsView.frame.width / 3) - 5
        let height = (buttonsView.frame.height / 4) - 5.5
        
        var index = 0
        
        for row in 0...3 {
            for column in 0...2 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: buttonsView.frame.width / 15)
                button.setTitle(pairs[index], for: .normal)
                button.setTitleColor(.clear, for: .normal)
                button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
                button.backgroundColor = .systemOrange
                button.layer.cornerRadius = 10
                
                let frame = CGRect(x: CGFloat(column) * (width + 7), y: CGFloat(row) * (height + 7), width: width, height: height)
                button.frame = frame
                buttonsView.addSubview(button)
                buttons.append(button)
                index += 1
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // create buttons after buttonsView appeared
        createButtons()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard isGameOver == false else { return }
        guard secondButton == nil else { return }
    
        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            sender.setTitleColor(.black, for: .normal)
        }) { finished in
            sender.isUserInteractionEnabled = false
            self.activatedButtons.append(sender)
        }
        
        if firstButton == nil {
            firstButton = sender
        } else if firstButton.titleLabel?.text == sender.titleLabel?.text {
            secondButton = sender
            
            // make buttons small
            UIView.animate(withDuration: 0.3, delay: 0.5 , animations: {
                sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.firstButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { finished in
                self.firstButton = nil
                self.secondButton = nil
                self.counter += 2
                
                if self.counter == self.buttons.count {
                    self.isGameOver = true
                    self.showAlert()
                }
            }
            
        } else {
            // reverse cards
            secondButton = sender
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.transition(with: self.firstButton, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    self.firstButton.setTitleColor(.clear, for: .normal)
                }) { finished in
                    self.firstButton.isUserInteractionEnabled = true
                    self.firstButton = nil
                }
                
                UIView.transition(with: self.secondButton, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    self.secondButton.setTitleColor(.clear, for: .normal)
                }) { finished in
                    self.secondButton.isUserInteractionEnabled = true
                    self.secondButton = nil
                    self.activatedButtons.removeLast(2)
                }
            }
        }
    }
    
    func showAlert() {
        let ac = UIAlertController(title: "You Win!", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Next Level", style: .default) { [weak self] _ in
            self?.level += 1
            self?.loadPairs()
            self?.resetButtons()
        })
        ac.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.level = 1
            self?.loadPairs()
            self?.resetButtons()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func newGameTapped() {
        level = 1
        loadPairs()
        resetButtons()
    }
    
    func newGame() {
        isGameOver = false
        counter = 0
        firstButton = nil
        secondButton = nil
        activatedButtons.removeAll()
        pairs.shuffle()
        
        for (index, button) in buttons.enumerated() {
            button.setTitle(pairs[index], for: .normal)
            button.isUserInteractionEnabled = true
        }
    }
    
    func resetButtons() {
        UIView.animate(withDuration: 0.3, animations: {
            for button in self.buttons {
                button.transform = .identity
            }
        }) { finished in
            for button in self.activatedButtons {
                UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    button.setTitleColor(.clear, for: .normal)
                }) { finished in
                    self.newGame()
                }
            }
        }
    }
    
    func loadPairs() {
        if level == 5 {
            level = 1
        }
        
        guard let pairsURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level\(level).txt in the app bundle.")
        }
        
        guard let pairsString = try? String(contentsOf: pairsURL) else {
            fatalError("Could not load level\(level).txt from the app bundle.")
        }
        
        pairs = pairsString.components(separatedBy: "\n")
    }
}

