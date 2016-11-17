//
//  ActionComponent.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

protocol StateAnimatable {
	var actionAnimations : Array<AnimationState> { get }
}

enum AnimationState {
	case idle	(SKAction)
	case flying	(SKAction)
	case jumping(SKAction)
}

class ActionComponent : GKComponent {

	var action : Action = .none
	var actionGuard : Set<Action> = []

	var stateMachine : GKStateMachine!

	var animation : Dictionary<GKState, SKAction> = [:]

	override func didAddToEntity() {

		guard let entity = entity as? StateAnimatable else {
			fatalError("guard let entity = entity as? StateAnimatable")
		}

		var states : Array<GKState> = []

		for state in entity.actionAnimations {
			switch state {
			case .idle(let action):
				let state = IdleState(self)
				states.append(state)
				animation[state] = action
			case .flying(let action):
				let state = FlyingState(self)
				states.append(state)
				animation[state] = action
			case .jumping(let action):
				let state = JumpingState(self)
				states.append(state)
				animation[state] = action
			}
		}

		stateMachine = GKStateMachine(states: states)

		stateMachine.enter(IdleState.self)
	}

	override func update(deltaTime seconds: TimeInterval) {

		let state = stateMachine.currentState

		switch (action.contains(.primary), actionGuard.contains(.primary)) {

		case (true, true) where state is IdleState: break
		case (false, false) where state is IdleState: break
		case (false, true) where state is IdleState: break
		case (true, false) where state is IdleState:
			stateMachine.enter(JumpingState.self)
			stateMachine.enter(FlyingState.self)
			break

		case (true, true) where state is JumpingState: break
		case (false, false) where state is JumpingState: break
		case (false, true) where state is JumpingState: break
		case (true, false) where state is JumpingState:
			stateMachine.enter(JumpingState.self)
			break

		case (true, true) where state is FlyingState: break
		case (false, false) where state is FlyingState: fallthrough
		case (false, true) where state is FlyingState:
			stateMachine.enter(IdleState.self)
			break
		case (true, false) where state is FlyingState:
			stateMachine.enter(FlyingState.self)
			break
		default: break
		}

//		if action.contains(.primary) {
//
//			stateMachine.enter(FlyingState.self)
//			stateMachine.enter(JumpingState.self)
//		} else if stateMachine.currentState is FlyingState {
//
//			stateMachine.enter(IdleState.self)
//		}

		stateMachine.update(deltaTime: seconds)
	}
}
