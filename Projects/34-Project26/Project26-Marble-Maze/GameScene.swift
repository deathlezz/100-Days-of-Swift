//
//  GameScene.swift
//  Project26-Marble-Maze
//
//  Created by deathlezz on 16/10/2022.
//

import SpriteKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case portal = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var levelCompletedLabel: SKLabelNode!
    var levelUpLabel: SKLabelNode!
    var gameOverLabel: SKSpriteNode!
    var newGameLabel: SKLabelNode!
    
    var levelLabel: SKLabelNode!
    var level = 1 {
        didSet {
            levelLabel.text = "Level \(level)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 35)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.position = CGPoint(x: 1008, y: 35)
        levelLabel.text = "Level 1"
        levelLabel.zPosition = 2
        levelLabel.horizontalAlignmentMode = .right
        addChild(levelLabel)
        
        // Challenge 2
        levelCompletedLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelCompletedLabel.text = "LEVEL COMPLETED"
        levelCompletedLabel.horizontalAlignmentMode = .center
        levelCompletedLabel.fontSize = 48
        levelCompletedLabel.zPosition = 2
        levelCompletedLabel.position = CGPoint(x: 512, y: 384)
        levelCompletedLabel.name = "levelCompleted"
        
        levelUpLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelUpLabel.text = "LEVEL UP"
        levelUpLabel.horizontalAlignmentMode = .center
        levelUpLabel.fontSize = 38
        levelUpLabel.zPosition = 2
        levelUpLabel.position = CGPoint(x: 512, y: 304)
        levelUpLabel.name = "levelUp"
        
        loadLevel()
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else {
            fatalError("Could not find level\(level).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not load level\(level).txt in the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: 64 * column + 32, y: 64 * row + 32)
                if letter == "x" {
                    // load wall
                    loadWall(at: position)
                } else if letter == "v" {
                    // load vortex
                    loadVortex(at: position)
                } else if letter == "s" {
                    // load star
                    loadStar(at: position)
                } else if letter == "f" {
                    // load finish point
                    loadFinishPoint(at: position)
                } else if letter == "p" {
                    // load portal
                    loadPortal(at: position)
                } else if letter == " " {
                    // this is an empty space - do nothing
                } else {
                    fatalError("Unknown level letter \(letter)")
                }
            }
        }
    }
    
    // Challenge 1
    func loadWall(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        addChild(node)
    }
    
    func loadPortal(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "portal")
        node.position = position
        node.name = "portal"
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.portal.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadVortex(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        addChild(node)
    }
    
    func loadStar(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
    
    func loadFinishPoint(at position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
    }
 
    func createPlayer() {
        guard isGameOver == false else { return }
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 96, y: 672)
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
        
        if isGameOver {
            let objects = nodes(at: location)
            
            for object in objects {
                if object.name == "levelUp" {
                    levelUp()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let difference = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: difference.x / 100, dy: difference.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level
            isGameOver = true
            node.removeFromParent()
            player.removeFromParent()
            score += 1
            addChild(levelCompletedLabel)
            addChild(levelUpLabel)
        }
    }
    
    func levelUp() {
        isGameOver = false
        level += 1

        for node in children {
            if node.name == "levelCompleted" || node.name == "levelUp" || node.name == "block" || node.name == "vortex" || node.name == "star" {
                node.removeFromParent()
            }
        }
        
        loadLevel()
        createPlayer()
    }
    
}
