//
//  GameScene.swift
//  Milestone-Projects16-18
//
//  Created by deathlezz on 14/09/2022.
//

import SpriteKit

class GameScene: SKScene {
    
    var charNode: SKSpriteNode!
    
    var background: SKSpriteNode!
    
    var grass1: SKSpriteNode!
    var grass2: SKSpriteNode!
    var grass3: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var bulletsLabel: SKLabelNode!
    var timeLeftLabel: SKLabelNode!
    var duckTimer: Timer?
    var gameTimer: Timer?
    
    var gameOverLabel: SKSpriteNode!
    
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
    
    var timeLeft = 59 {
        didSet {
            timeLeftLabel.text = ":\(timeLeft)"
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
        bulletsLabel.name = "BulletsLabel"
        addChild(bulletsLabel)
        
        timeLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLeftLabel.fontSize = 60
        timeLeftLabel.position = CGPoint(x: 512, y: 50)
        timeLeftLabel.horizontalAlignmentMode = .center
        timeLeftLabel.zPosition = 6
        addChild(timeLeftLabel)
        
        gameOverLabel = SKSpriteNode(imageNamed: "gameOver")
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 6
        gameOverLabel.name = "gameOverLabel"
        
        newGame()
    }
    
    @objc func createDuck() {
        if timeLeft > 0 {
            
            if Int.random(in: 0...2) == 0 {
                createCharacter(type: "duck", duration: Double.random(in: 2...4))
            } else {
                createCharacter(type: "enemy", duration: Double.random(in: 2...4))
            }
            
            duckTimer?.invalidate()
            duckTimer = Timer.scheduledTimer(timeInterval: Double.random(in: 0.35...2), target: self, selector: #selector(createDuck), userInfo: nil, repeats: true)
        } else {
            gameOver()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if timeLeft > 0 {
                if node.name == "slowDuck" && bullets > 0 {
                    node.removeFromParent()
                    score -= 2
                    bullets -= 1
                } else if node.name == "slowEnemy" && bullets > 0 {
                    node.removeFromParent()
                    score += 1
                    bullets -= 1
                } else if node.name == "fastDuck" && bullets > 0 {
                    node.removeFromParent()
                    score -= 3
                    bullets -= 1
                } else if node.name == "fastEnemy" && bullets > 0 {
                    node.removeFromParent()
                    score += 2
                    bullets -= 1
                } else if node.name == "BulletsLabel" && bullets < 6 {
                    bullets = 6
                    bulletsLabel.text = "Bullets: \(bullets)"
                }
            }
        }
        
        if bullets == 0 {
            bulletsLabel.text = "RELOAD"
        }
    }
    
    func createCharacter(type: String, duration: Double) {
        let heights = [200, 305, 410]
        
        charNode = SKSpriteNode(imageNamed: "duckLeft")
        charNode.position = CGPoint(x: -50, y: heights.randomElement()!)
        
        if duration > 2.5 {
            charNode.name = "slow\(type.capitalized)"
        } else {
            charNode.name = "fast\(type.capitalized)"
            charNode.xScale = 0.8
            charNode.yScale = 0.8
        }

        if charNode.position.y == 200 {
            charNode.texture = SKTexture(imageNamed: "\(type)Right")
            charNode.position.x = -70
            charNode.zPosition = 4
        } else if charNode.position.y == 305 {
            charNode.texture = SKTexture(imageNamed: "\(type)Left")
            charNode.position.x = 1100
            charNode.zPosition = 2
        } else if charNode.position.y == 410 {
            charNode.texture = SKTexture(imageNamed: "\(type)Right")
            charNode.position.x = -70
            charNode.zPosition = 0
        }
        
        addChild(charNode)
        
        if charNode.zPosition == 4 || charNode.zPosition == 0 && charNode.position.x == -70 {
            charNode.run(SKAction.moveBy(x: 1300, y: 0, duration: duration))
        } else if charNode.zPosition == 2 && charNode.position.x == 1100 {
            charNode.run(SKAction.moveBy(x: -1300, y: 0, duration: duration))
        }
    }
    
    func gameOver() {
        gameTimer?.invalidate()
        duckTimer?.invalidate()
        
        addChild(gameOverLabel)
        
        for node in children {
            if node.name == "slowDuck" || node.name == "fastDuck" || node.name == "slowEnemy" || node.name == "fastEnemy" {
                node.removeFromParent()
            }
        }
    }

    func newGame() {
        score = 0
        bullets = 6
        timeLeft = 59
        
        createDuck()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        timeLeft -= 1
    }
}
