//
//  Flying.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 14/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class FlyingState : GKState {

	unowned var insect : Insect

	init(_ insect : Insect) {
		self.insect = insect
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is IdleState.Type
	}

	override func didEnter(from previousState: GKState?) {

		insect.movementSpeed = 180
		insect.run(insect.action)

		let upscale = SKAction.scale(to: 1.5, duration: 0.5)
		insect.run(upscale)
	}

	override func willExit(to nextState: GKState) {

		let downscale = SKAction.scale(to: 1, duration: 0.5)
		insect.run(downscale)
	}

	override func update(deltaTime seconds: TimeInterval) {

		if !insect.isActing {
			stateMachine?.enter(IdleState.self)
		}
	}
}
