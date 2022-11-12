//
//  ViewController.swift
//  Milestone-Projects28-30
//
//  Created by deathlezz on 11/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var isGameOver = false
    var firstButton: UIButton!
    var secondButton: UIButton!
    
    var pairs = ["apple", "tomato", "potato", "carrot", "pineapple", "cucumber", "apple", "tomato", "potato", "carrot", "pineapple", "cucumber"]
    
    var buttonsView: UIView!
    var buttons = [UIButton]()
    var counter = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(gridTapped))
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
    
        sender.setTitleColor(.black, for: .normal)
        sender.isUserInteractionEnabled = false
        
        if firstButton == nil {
            firstButton = sender
        } else if firstButton.titleLabel?.text == sender.titleLabel?.text {
            secondButton = sender
            
            // make buttons small
            UIView.animate(withDuration: 0.3, delay: 0.5 , animations: { [weak self] in
                sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self?.firstButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { finished in
                self.firstButton = nil
                self.secondButton = nil
                self.counter += 2
                
                if self.counter == 2 {
                    self.gameOver()
                }
            }
            
        } else {
            // reverse cards
            secondButton = sender
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.transition(with: self.firstButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.firstButton.setTitleColor(.clear, for: .normal)
                }) { finished in
                    self.firstButton.isUserInteractionEnabled = true
                    self.firstButton = nil
                }
                
                UIView.transition(with: self.secondButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.secondButton.setTitleColor(.clear, for: .normal)
                }) { finished in
                    self.secondButton.isUserInteractionEnabled = true
                    self.secondButton = nil
                }
            }
        }
    }
    
    @objc func newGameTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            for button in self.buttons {
                button.transform = .identity
                button.setTitleColor(.clear, for: .normal)
            }
        }) { finished in
            self.newGame()
        }
    }
    
    @objc func gridTapped() {
        let ac = UIAlertController(title: "Select grid", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "3 x 4 grid", style: .default))
        ac.addAction(UIAlertAction(title: "4 x 5 grid", style: .default))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func newGame() {
        isGameOver = false
        counter = 0
        firstButton = nil
        secondButton = nil
        pairs.shuffle()
        
        for (index, button) in buttons.enumerated() {
            button.setTitle(pairs[index], for: .normal)
            button.isUserInteractionEnabled = true
        }
        
        navigationItem.leftBarButtonItem?.title = "New Game"
    }
    
    func gameOver() {
        isGameOver = true
        navigationItem.leftBarButtonItem?.title = "Continue"
    }
}

