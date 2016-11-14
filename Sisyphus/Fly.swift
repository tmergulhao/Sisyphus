//
//  Fly.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class Fly : Insect {

	override var idle : SKAction {
		return Insect.animation(with: "idle_", numberOfTextures: 3, atlasName: "fly", timePerFrame: 0.2)
	}

	override var action : SKAction {
		return Insect.animation(with: "flying_", numberOfTextures: 2, atlasName: "fly", timePerFrame: 0.2)
	}

	override init () {
		super.init()

		name = "fly"

		states = GKStateMachine(states: [IdleState(self), FlyingState(self)])

		states.enter(IdleState.self)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
