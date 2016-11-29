//
//  InsectEntity.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

class MiteEntity : GKEntity, StateAnimatable {

	var actionAnimations : Array<AnimationState> = [
		.idle	(RenderComponent.animation(textureHandle: "idle_", numberOfTextures: 3, atlasName: "mite", timePerFrame: 0.08)),
		.jumping(RenderComponent.animation(textureHandle: "idle_", numberOfTextures: 3, atlasName: "mite", timePerFrame: 0.2))
	]

	override init () {

		super.init()

		let render = RenderComponent()

		render.size = CGSize(width: 32, height: 32)

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
