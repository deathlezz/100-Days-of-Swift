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
    
    override func didMove(to view: SKView) {
        
        background = SKSpriteNode(imageNamed: "background")
        background.blendMode = .replace
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        addChild(background)
        
        grass1 = SKSpriteNode(imageNamed: "grass1")
        grass1.position = CGPoint(x: 512, y: 384)
        addChild(grass1)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
    }
}
