//
//  GameViewController.swift
//  Project29-Exploding-Monkeys
//
//  Created by deathlezz on 31/10/2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var scoreLabel: UILabel!
    
    var player1Score = 0 {
        didSet {
            scoreLabel.text = "\(player1Score):\(player2Score)"
        }
    }
    
    var player2Score = 0 {
        didSet {
            scoreLabel.text = "\(player1Score):\(player2Score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player1Score = 0
        player2Score = 0
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        launchButton.isHidden = false
    }
    
    func playerScored(player: Int) {
        if player == 1 {
            player1Score += 1
        } else {
            player2Score += 1
        }
        
        if player1Score == 3 {
            playerNumber.text = "PLAYER 1 WINS"
            // game over
        } else if player2Score == 3 {
            playerNumber.text = "PLAYER 2 WINS"
            // game over
        }
    }
    
    func gameOver() {
        
    }
    
    func newGame() {
        
    }
    
}
