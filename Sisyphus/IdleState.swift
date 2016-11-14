//
//  InsectStateMachine.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 13/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class IdleState : GKState {

	unowned var insect : Insect

	init(_ insect : Insect) {
		self.insect = insect
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is FlyingState.Type, is JumpingState.Type: return true
		default: return false
		}
	}

	override func didEnter(from previousState: GKState?) {
		insect.movementSpeed = 60
		insect.run(insect.idle)
	}

	override func willExit(to nextState: GKState) {}

	override func update(deltaTime seconds: TimeInterval) {

		if insect.isActing {
			stateMachine?.enter(FlyingState.self)
			stateMachine?.enter(JumpingState.self)
		}
	}
}
