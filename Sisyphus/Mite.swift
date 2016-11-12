//
//  Mite.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

class Mite : Insect {

	static let idle : SKAction = {
		return Insect.animation(with: "idle_", numberOfTextures: 2, atlasName: "mite", timePerFrame: 0.2)
	}()

	static let action : SKAction = {
		return Insect.animation(with: "idle_", numberOfTextures: 2, atlasName: "mite", timePerFrame: 0.08)
	}()

	var isJumping : Bool = false

	override func changeState(from before: InsectState, to after: InsectState) {
		removeAllActions()

		if after == .action {

			if !isJumping {
				isJumping = true

				let upscale = SKAction.scale(by: 2, duration: 0.5)

				self.run(upscale, completion: {
					self.isJumping = false

					let downscale = SKAction.scale(by: 0.5, duration: 0.5)
					self.run(downscale)
				})
			}
		}

		switch after {
		case .action: run(Mite.action)
		case .moving: run(Mite.action)
		case .idle: run(Mite.idle)
		default: break
		}
	}

	override init () {
		super.init()
		name = "mite"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
