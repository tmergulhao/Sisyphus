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

	let fontName = "Computer Pixel-7"
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
	var keys: Set<GameKeys> = []

    var label : SKLabelNode?
    
    override func sceneDidLoad() {

		self.backgroundColor = NSColor.white

		let idle_cockroach = Cockroach()
		idle_cockroach.state = .idle

		idle_cockroach.position = CGPoint(x: -frame.height/4, y: 0)

		self.addChild(idle_cockroach)

		let flying_cockroach = Cockroach()
		flying_cockroach.state = .flying

		flying_cockroach.position = CGPoint(x: frame.height/4, y: 0)

		self.addChild(flying_cockroach)

		let label = SKLabelNode(fontNamed: fontName)

		label.text = "Hello World!"
		label.fontColor = SKColor.black
		label.fontSize = 30
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .baseline

		label.position = CGPoint(x: 0, y: frame.height/4)

		self.label = label

		self.addChild(label)
    }

	var previousTime : TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {

        if (previousTime == 0) {
            previousTime = currentTime
        }

		let deltaTime = previousTime - currentTime

        for entity in self.entities {
            entity.update(deltaTime: deltaTime)
        }
        
        previousTime = currentTime
    }
	override func mouseDown(with event: NSEvent) {
		Swift.print(event.location(in: self))
	}
}
