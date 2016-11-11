//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
	var keys: Set<GameKeys> = []
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0

        let typedLabel = TypedLabel(typingInterval: 10000, fontNamed: "Computer Pixel-7", andText: "Hello World")

//      typedLabel.fontName = "Computer Pixel-7"
//		typedLabel.fontColor = SKColor.white
//		typedLabel.fontSize = 30
//		typedLabel.horizontalAlignmentMode = .center
//		typedLabel.verticalAlignmentMode = .baseline
		typedLabel.position = CGPoint(x: 100, y: 100)// CGPoint(x: size.width / 2.0, y: size.height / 3.0)

		self.addChild(typedLabel)

		typedLabel.type()
    }

//	fileprivate var previousTime: TimeInterval = 0
//	fileprivate var deltaTime: TimeInterval = 0
//
//	func update(_ currentTime: TimeInterval, for scene: SKScene) {
//
//		if previousTime == 00 {
//			previousTime = currentTime
//		}
//
//		deltaTime = currentTime - previousTime
//		previousTime = currentTime
//
//		guard let level = scene as? GameScene else { return }
//
//		let key = level.keys
//
//		if key.contains(.left) {
//			pressingLeft = true
//		}
//
//		if key.contains(.right) {
//			pressingRight = true
//		}
//
//		if key.contains(.jump) {
//			pressingJump = true
//		}
//	}

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
