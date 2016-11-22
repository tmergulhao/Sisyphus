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

	var player : GKEntity!

	override func sceneDidLoad() {

		onScreenControls(directional: [.up, .down, .left, .right], action: [.primary])
	
		player = randomInsect()

		entities.append(player)

		guard let node = player.component(ofType: RenderComponent.self)?.spriteNode else {
			fatalError("No sprite node on RenderComponent")
		}

		addChild(node)

		setupInsectarium()

		super.sceneDidLoad()
	}

	var previousTime : TimeInterval = 0

	func updatePlayerControls () {

		if let movementComponent = player.component(ofType: MovementComponent.self) {

			movementComponent.directional = directional
			movementComponent.directionalGuard = directionalGuard
		}

		if let actionComponent = player.component(ofType: ActionComponent.self) {

			actionComponent.action = action
			actionComponent.actionGuard = actionGuard
		}
	}

	override func update(_ currentTime: TimeInterval) {

		updatePlayerControls()

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime

		for entity in entities {

			entity.update(deltaTime: deltaTime)
		}

		previousTime = currentTime

		super.update(currentTime)
	}
}
