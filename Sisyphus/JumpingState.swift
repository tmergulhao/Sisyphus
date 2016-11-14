//
//  Jump.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 14/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class JumpingState : GKState {

	unowned var insect : Insect

	var isJumping : Bool = false

	init(_ insect : Insect) {
		self.insect = insect
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is IdleState.Type
	}
	
	override func didEnter(from previousState: GKState?) {
		isJumping = true

		let upscale = SKAction.scale(to: 2, duration: 0.5)
		let downscale = SKAction.scale(to: 1, duration: 0.5)
		let jump = SKAction.sequence([upscale, downscale])

		insect.run(jump) { [unowned self] in
			self.isJumping = false
		}
	}

	override func willExit(to nextState: GKState) {}

	override func update(deltaTime seconds: TimeInterval) {

		if !isJumping {
			stateMachine?.enter(IdleState.self)
		}
	}
}
