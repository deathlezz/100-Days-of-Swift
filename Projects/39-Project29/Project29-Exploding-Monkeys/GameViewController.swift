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
    
    // Challenge 3
    @IBOutlet var player1Wind: UILabel!
    @IBOutlet var player2Wind: UILabel!
    
    // Challenge 1
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var newGameButton: UIButton!
    
    var isGameOver = false {
        didSet {
            newGameButton.isHidden = !isGameOver
        }
    }
    
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
        newGameButton.isHidden = true
        player1Wind.isHidden = false
        player2Wind.isHidden = true
        
        player1Wind.text = ""
        player2Wind.text = ""
        
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
        
        currentGame?.addWind()
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
        hud(isHidden: true)
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
            player1Wind.isHidden = false
            player2Wind.isHidden = true
        } else {
            playerNumber.text = "PLAYER TWO >>>"
            player1Wind.isHidden = true
            player2Wind.isHidden = false
        }
        
        hud(isHidden: false)
    }
    
    func playerScored(player: Int) {
        if player == 1 {
            player1Score += 1
        } else {
            player2Score += 1
        }
        
        if player1Score == 3 {
            playerNumber.text = "PLAYER 1 WINS"
            gameOver()
        } else if player2Score == 3 {
            playerNumber.text = "PLAYER 2 WINS"
            gameOver()
        }
    }
    
    // Challenge 1
    func hud(isHidden: Bool) {
        angleSlider.isHidden = isHidden
        angleLabel.isHidden = isHidden
        velocitySlider.isHidden = isHidden
        velocityLabel.isHidden = isHidden
        launchButton.isHidden = isHidden
    }
    
    func gameOver() {
        hud(isHidden: true)
        isGameOver = true
        player1Wind.isHidden = true
        player2Wind.isHidden = true
    }
    
    @IBAction func newGame(_ sender: Any) {
        player1Score = 0
        player2Score = 0
        hud(isHidden: false)
        isGameOver = false
        currentGame?.newGame()
    }
    
}
