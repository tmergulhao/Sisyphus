//
//  Fly.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

class Fly : Insect {

	static let idle : SKAction = {
		return Insect.animation(with: "idle_", numberOfTextures: 3, atlasName: "fly", timePerFrame: 0.2)
	}()

	static let action : SKAction = {
		return Insect.animation(with: "flying_", numberOfTextures: 2, atlasName: "fly", timePerFrame: 0.2)
	}()

	override func changeState(from before: InsectState, to after: InsectState) {
		removeAllActions()

		if after == .action {
			let upscale = SKAction.scale(by: 2, duration: 0.5)
			run(upscale)
		}

		if before == .action {
			let downscale = SKAction.scale(by: 0.5, duration: 0.5)
			run(downscale)
		}

		switch after {
		case .action: run(Fly.action)
		case .moving: run(Fly.action)
		case .idle: run(Fly.idle)
		default: break
		}
	}

	override init () {
		super.init()
		name = "fly"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
