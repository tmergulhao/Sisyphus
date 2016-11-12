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

	var keys : Set<GameKeys> = []

	var entities : Array<GKEntity> = [GKEntity]()
	var graphs : Dictionary<String, GKGraph> = [String : GKGraph]()

    var label : SKLabelNode?

	var cockroach : Cockroach?
	var mite : Mite?
	var fly : Fly?

	func addItems () {

		let cockroach = Cockroach()

		cockroach.position = CGPoint(x: 0, y: 0)

		self.cockroach = cockroach
		addChild(cockroach)

		let mite = Mite()

		mite.position = CGPoint(x: -0.33*frame.width, y: 0)

		self.mite = mite
		addChild(mite)

		let fly = Fly()

		fly.position = CGPoint(x: 0.33*frame.width, y: 0)

		self.fly = fly
		addChild(fly)

	}
    
    override func sceneDidLoad() {

		backgroundColor = NSColor.white

		addItems()

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

		if keys.contains(.action) {
			cockroach?.state = .flying
			mite?.state = .jumping
			fly?.state = .flying
		} else {
			cockroach?.state = .idle
			mite?.state = .idle
			fly?.state = .idle
		}

        for entity in self.entities {
            entity.update(deltaTime: deltaTime)
        }

        previousTime = currentTime
    }
}
