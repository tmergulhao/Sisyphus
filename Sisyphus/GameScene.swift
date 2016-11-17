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

	override func sceneDidLoad() {

		onScreenControls(directional: [.up, .down, .left, .right], action: [.primary])

		let entity : GKEntity!

		let index = Int(arc4random_uniform(UInt32(3)))
	
		switch index {
		case 0: entity = MiteEntity()
		case 1: entity = FlyEntity()
		case 2: fallthrough
		default: entity = CockroachEntity()
		}

		entities.append(entity)

		guard let node = entity.component(ofType: RenderComponent.self)?.spriteNode else {
			fatalError("No sprite node on RenderComponent")
		}

		addChild(node)

		super.sceneDidLoad()
	}

	var previousTime : TimeInterval = 0

	override func update(_ currentTime: TimeInterval) {

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime

		for entity in entities {
			
			if let movementComponent = entity.component(ofType: MovementComponent.self) {

				movementComponent.directional = directional
				movementComponent.directionalGuard = directionalGuard
			}

			if let actionComponent = entity.component(ofType: ActionComponent.self) {

				actionComponent.action = action
				actionComponent.actionGuard = actionGuard
			}

			entity.update(deltaTime: deltaTime)
		}

		previousTime = currentTime

		super.update(currentTime)
	}
}
