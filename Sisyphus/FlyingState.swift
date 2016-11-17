//
//  Flying.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 14/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class FlyingState : GKState {

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

		return stateClass is IdleState.Type
	}

	override func didEnter(from previousState: GKState?) {

		movement?.speed = 180

		let upscale = SKAction.scale(to: 1.5, duration: 0.5)
		
		render?.spriteNode.run(action.animation[self]!)
		render?.spriteNode.run(upscale)
	}

	override func willExit(to nextState: GKState) {

		let downscale = SKAction.scale(to: 1, duration: 0.5)

		render?.spriteNode.run(downscale)
	}
}
