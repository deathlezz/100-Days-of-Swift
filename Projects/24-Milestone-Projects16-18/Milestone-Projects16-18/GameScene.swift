//
//  GameScene.swift
//  Milestone-Projects16-18
//
//  Created by deathlezz on 14/09/2022.
//

import SpriteKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    
    var grass1: SKSpriteNode!
    var grass2: SKSpriteNode!
    var grass3: SKSpriteNode!
    
    var duckRight: SKSpriteNode!
    var enemyRight: SKSpriteNode!
    var enemyLeft: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var bulletsLabel: SKLabelNode!
    var gameTimer: Timer?
    var isGameOver = false
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bullets = 6 {
        didSet {
            bulletsLabel.text = "Bullets: \(bullets)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        grass1 = SKSpriteNode(imageNamed: "grass1")
        grass1.position = CGPoint(x: 512, y: 120)
        grass1.zPosition = 5
        addChild(grass1)
        
        grass2 = SKSpriteNode(imageNamed: "grass2")
        grass2.position = CGPoint(x: 512, y: 225)
        grass2.zPosition = 3
        addChild(grass2)
        
        grass3 = SKSpriteNode(imageNamed: "grass3")
        grass3.position = CGPoint(x: 512, y: 330)
        grass3.zPosition = 1
        addChild(grass3)
        
//        duckRight = SKSpriteNode(imageNamed: "duckRight")
//        duckRight.position = CGPoint(x: 250, y: 200)
//        duckRight.zPosition = 4
//        addChild(duckRight)
//
//        enemyLeft = SKSpriteNode(imageNamed: "enemyLeft")
//        enemyLeft.position = CGPoint(x: 900, y: 305)
//        enemyLeft.zPosition = 2
//        addChild(enemyLeft)
//
//        enemyRight = SKSpriteNode(imageNamed: "enemyRight")
//        enemyRight.position = CGPoint(x: 250, y: 410)
//        enemyRight.zPosition = 0
//        addChild(enemyRight)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.fontSize = 42
        scoreLabel.position = CGPoint(x: 10, y: 40)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 6
        addChild(scoreLabel)
        
        bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletsLabel.fontSize = 42
        bulletsLabel.position = CGPoint(x: 1014, y: 40)
        bulletsLabel.horizontalAlignmentMode = .right
        bulletsLabel.zPosition = 6
        addChild(bulletsLabel)
        
        newGame()
    }
    
    @objc func createDuck() {
        if !isGameOver {
            let heights = [200, 410]
            let sprite = SKSpriteNode(imageNamed: "enemyRight")
            sprite.position = CGPoint(x: -50, y: heights.randomElement()!)
            sprite.name = "Enemy"
            
            if sprite.position.y == 200 {
                sprite.zPosition = 4
            } else {
                sprite.zPosition = 0
            }
            
            addChild(sprite)
            
            sprite.run(SKAction.moveBy(x: 1150, y: 0, duration: 4))
            
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in children {
            if node.position.x > 1100 {
                node.removeFromParent()
            }
        }
    }
    
    func newGame() {
        score = 0
        bullets = 6
        isGameOver = false
        
        createDuck()
    }
}
