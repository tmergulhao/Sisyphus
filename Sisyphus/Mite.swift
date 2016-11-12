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

	override func changeState(from before: InsectState, to after: InsectState) {
		removeAllActions()

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
