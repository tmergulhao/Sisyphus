//
//  InsectStateMachine.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 13/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class IdleState : GKState {

	unowned var action : ActionComponent

	var entity : GKEntity { return action.entity! }

	var movement : MovementComponent?
	var render : RenderComponent?

	init(_ action : ActionComponent) {

		self.action = action

		super.init()

		movement = entity.component(ofType: MovementComponent.self)
		render = entity.component(ofType: RenderComponent.self)
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {

		return true
	}

	override func didEnter(from previousState: GKState?) {

		movement?.speed = 60
		render?.spriteNode?.run(action.animation[self]!)
	}
}
