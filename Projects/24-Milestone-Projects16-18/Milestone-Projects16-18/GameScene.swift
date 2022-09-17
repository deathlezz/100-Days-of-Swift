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
    
    var enemies = ["enemyRight", "enemyLeft"]
    var friends = ["duckRight", "duckLeft"]
    
//    var duckRight: SKSpriteNode!
//    var enemyRight: SKSpriteNode!
//    var enemyLeft: SKSpriteNode!
    
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
            
            if Int.random(in: 0...2) == 0 {
                createFriend()
            } else {
                createEnemy()
            }
            
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.75...3), target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
        }
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in children {
            if node.position.x > 1150 && node.position.x < -100 {
                node.removeFromParent()
            }
        }
    }
    
    func createEnemy() {
        let heights = [200, 305, 410]
//            let widths = [-50, 1100]
        let enemy = SKSpriteNode(imageNamed: "duckLeft")
        enemy.position = CGPoint(x: -50, y: heights.randomElement()!)
        
        enemy.name = "Enemy"
        
        if enemy.position.y == 200 {
            enemy.texture = SKTexture(imageNamed: "enemyRight")
            enemy.zPosition = 4
            enemy.position.x = -50
        } else if enemy.position.y == 305 {
            enemy.texture = SKTexture(imageNamed: "enemyLeft")
            enemy.zPosition = 2
            enemy.position.x = 1100
        } else {
            enemy.texture = SKTexture(imageNamed: "enemyRight")
            enemy.zPosition = 0
            enemy.position.x = -50
        }
        
        addChild(enemy)
        
        if enemy.zPosition == 4 || enemy.zPosition == 0 && enemy.position.x == -50 {
            enemy.run(SKAction.moveBy(x: 1200, y: 0, duration: 4))
        } else if enemy.zPosition == 2 && enemy.position.x == 1100 {
            enemy.run(SKAction.moveBy(x: -1300, y: 0, duration: 4))
        }
    }
    
    func createFriend() {
        let heights = [200, 305, 410]
//            let widths = [-50, 1100]
        let friend = SKSpriteNode(imageNamed: "duckLeft")
        friend.position = CGPoint(x: -50, y: heights.randomElement()!)
        
        friend.name = "Friend"
        
        if friend.position.y == 200 {
            friend.texture = SKTexture(imageNamed: "duckRight")
            friend.zPosition = 4
            friend.position.x = -50
        } else if friend.position.y == 305 {
            friend.texture = SKTexture(imageNamed: "duckLeft")
            friend.zPosition = 2
            friend.position.x = 1100
        } else {
            friend.texture = SKTexture(imageNamed: "duckRight")
            friend.zPosition = 0
            friend.position.x = -50
        }
        
        addChild(friend)
        
        if friend.zPosition == 4 || friend.zPosition == 0 && friend.position.x == -50 {
            friend.run(SKAction.moveBy(x: 1200, y: 0, duration: 4))
        } else if friend.zPosition == 2 && friend.position.x == 1100 {
            friend.run(SKAction.moveBy(x: -1300, y: 0, duration: 4))
        }
    }

    func newGame() {
        score = 0
        bullets = 6
        isGameOver = false
        
        createDuck()
    }
}
