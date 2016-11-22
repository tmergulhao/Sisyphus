//
//  FlyEntity.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class FlyEntity : GKEntity, StateAnimatable {

	var actionAnimations : Array<AnimationState> = [
		.idle	(RenderComponent.animation(textureHandle: "idle_", numberOfTextures: 3, atlasName: "fly", timePerFrame: 0.2)),
		.flying	(RenderComponent.animation(textureHandle: "flying_", numberOfTextures: 2, atlasName: "fly", timePerFrame: 0.2))
	]

	override init () {

		super.init()

		let render = RenderComponent()

		render.size = CGSize(width: 64, height: 64)
		
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
