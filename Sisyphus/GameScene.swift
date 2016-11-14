//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene : Scene {

	var insect : Insect!

	override func sceneDidLoad() {

		onScreenControls(directional: [.up, .down, .left, .right], action: [.primary])

		backgroundColor = NSColor.white

		insect = Insect.randomInsect()

		insect.position = CGPoint(x: 0, y: 0)

		addChild(insect)

		super.sceneDidLoad()
	}

	override func update(_ currentTime: TimeInterval) {

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime

		insect.act(onDirectional: directional, directionalGuard: directionalGuard, action : action, actionGuard : actionGuard, interval: deltaTime)

		insect.states.update(deltaTime: deltaTime)
	
		for entity in self.entities {
			entity.update(deltaTime: deltaTime)
		}

		previousTime = currentTime
	}
}
