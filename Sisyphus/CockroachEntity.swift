//
//  CockroachEntity.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class CockroachEntity : GKEntity, StateAnimatable {

	var actionAnimations : Array<AnimationState> = [
		.moving	(RenderComponent.animation(textureHandle: "moving_", numberOfTextures: 3, atlasName: "cockroach", timePerFrame: 0.2)),
		.idle	(RenderComponent.animation(textureHandle: "idle_", numberOfTextures: 6, atlasName: "cockroach", timePerFrame: 0.2)),
		.flying	(RenderComponent.animation(textureHandle: "flying_", numberOfTextures: 3, atlasName: "cockroach", timePerFrame: 0.08))
	]

	override init () {

		super.init()

		let render = RenderComponent()

		render.size = CGSize(width: 128, height: 128)
		
		addComponent(render)

		let movement = MovementComponent()
		addComponent(movement)

		let action = ActionComponent()
		addComponent(action)
	}

	required init?(coder aDecoder: NSCoder) {

		fatalError("init(coder:) has not been implemented")
	}
}
