//
//  GameScene.swift
//  Project11-Pachinko
//
//  Created by deathlezz on 06/08/2022.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let balls = ["ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballRed", "ballYellow"]
    
    var ballsLeft = 5 {
        didSet {
            ballsLeftLabel.text = "Balls: \(ballsLeft)"
        }
    }
    
    var ballsLeftLabel: SKLabelNode!
    
    var boxesLeft = 17
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var newGameLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        newGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        newGameLabel.text = "New Game"
        newGameLabel.position = CGPoint(x: 120, y: 700)
        addChild(newGameLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLeftLabel.text = "Balls: 5"
        ballsLeftLabel.position = CGPoint(x: 500, y: 700)
        addChild(ballsLeftLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        newGame()
    }
    
    func newGame() {
        ballsLeft = 5
        
        for node in children {
            if node.name == "ball" || node.name == "box" {
                node.removeFromParent()
            }
        }
        
        makeRandomBoxes()
    }
    
    func restart(_ action: UIAlertAction) {
        newGame()
        score = 0
    }
    
    func levelUp(_ action: UIAlertAction) {
        newGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(newGameLabel) {
            newGame()
            score = 0
            
        } else {
            if ballsLeft > 0 {
                let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballRed")
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = CGPoint(x: location.x, y: 700)
                ball.name = "ball"
                ballsLeft -= 1
                addChild(ball)
            }
        }
    }
    
    func makeRandomBoxes() {
        for _ in 0...16 {
            let size = CGSize(width: Int.random(in: 50...128), height: 16)
            let box = SKSpriteNode(color: boxColor(), size: size)
            let position = CGPoint(x: CGFloat.random(in: 50...950), y: CGFloat.random(in: 200...500))
            
            box.zRotation = CGFloat.random(in: 0...2)
            box.position = position
            box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
            box.physicsBody?.isDynamic = false
            box.name = "box"
            addChild(box)
        }
    }
    
    func boxColor() -> UIColor {
        let colors = [UIColor.magenta, UIColor.red, UIColor.green, UIColor.blue, UIColor.orange]
        return colors.randomElement()!
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }

    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            ballsLeft += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
        } else if object.name == "box" {
            object.removeFromParent()
            score += 1
            boxesLeft -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fileParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fileParticles.position = ball.position
            addChild(fileParticles)
        }
        
        ball.removeFromParent()
        
        if ballsLeft == 0 && boxesLeft > 0 {
            let ac = UIAlertController(title: "Game Over", message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "New Game", style: .default, handler: restart))
            view?.window?.rootViewController?.present(ac, animated: true)
        } else if boxesLeft == 0 {
            let ac = UIAlertController(title: "Level completed!", message: "Are you ready for the next level?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: levelUp))
            view?.window?.rootViewController?.present(ac, animated: true)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
