//
//  GameScene.swift
//  Project17-Space-Race
//
//  Created by deathlezz on 09/09/2022.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var newGameLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var seconds: Double = 1
    var counter = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 40)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 1
        addChild(scoreLabel)

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        newGame()
    }
    
    @objc func createEnemy() {
        if !isGameOver {
            guard let enemy = possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            sprite.name = "Enemy"
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            counter += 1
            
            if counter % 20 == 0 {
                seconds -= 0.1
            } else if seconds == 0 {
                seconds = 1
            }
            
            gameTimer?.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !isGameOver {
            score += 1
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !isGameOver else { return }
        gameOver()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if !isGameOver {
            gameOver()
            return
        }
        
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        for object in objects {
            if object.name == "NewGame" {
                newGame()
            }
        }
    }
    
    func gameOver() {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
        
        gameTimer?.invalidate()
        
        gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.name = "GameOver"
        gameOverLabel.fontSize = 45
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.horizontalAlignmentMode = .center
        addChild(gameOverLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "NEW GAME"
        newGameLabel.name = "NewGame"
        newGameLabel.fontSize = 25
        newGameLabel.position = CGPoint(x: 512, y: 300)
        newGameLabel.zPosition = 1
        newGameLabel.horizontalAlignmentMode = .center
        addChild(newGameLabel)
    }
    
    func newGame() {
        score = 0
        seconds = 1
        counter = 0
        isGameOver = false
        
        for node in children {
            if node.name == "NewGame" || node.name == "GameOver" || node.name == "Enemy" {
                node.removeFromParent()
            }
        }
        
        player.position = CGPoint(x: 100, y: 384)
        addChild(player)
        
        gameTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
}
