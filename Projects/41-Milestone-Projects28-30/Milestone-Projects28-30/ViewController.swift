//
//  ViewController.swift
//  Milestone-Projects28-30
//
//  Created by deathlezz on 11/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var buttonsView: UIView!
    
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
        navigationItem.leftBarButtonItem?.isHidden = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Grid", style: .plain, target: self, action: #selector(gridTapped))
        
    }
    
    func createButtons() {
        let width = (buttonsView.frame.width / 3) - 5
        let height = (buttonsView.frame.height / 4) - 5.5
        
        for row in 0...3 {
            for column in 0...2 {
                let button = UIButton(type: .system)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                button.setTitle("BUTTON", for: .normal)
                button.backgroundColor = .darkGray
                button.layer.cornerRadius = 10
                
                let frame = CGRect(x: CGFloat(column) * (width + 7), y: CGFloat(row) * (height + 7), width: width, height: height)
                button.frame = frame
                buttonsView.addSubview(button)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // create buttons after buttonsView appeared
        createButtons()
    }
    
    @objc func newGameTapped() {
        
    }
    
    @objc func gridTapped() {
        
    }
}

