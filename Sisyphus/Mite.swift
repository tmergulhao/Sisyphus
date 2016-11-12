//
//  Mite.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum MiteState {
	case none
	case jumping
	case idle
}

class Mite : SKSpriteNode {

	fileprivate static let atlas = { return SKTextureAtlas(named: "mite") }()

	fileprivate static let idle : SKAction = {
		let textures = (1...2).map { atlas.textureNamed("idle_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate static let jumping : SKAction = {
		let textures = (1...2).map { atlas.textureNamed("idle_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.08)

		return SKAction.repeatForever(action)
	}()

	fileprivate var lastState : MiteState = .none
	var state : MiteState = .idle {
		didSet {
			if lastState != state {
				lastState = state
				removeAllActions()

				switch state {
				case .jumping: run(Mite.jumping)
				case .idle: run(Mite.idle)
				default: break
				}
			}
		}
	}

	init () {
		let texture = Mite.atlas.textureNamed("idle_1")

		super.init(texture: nil, color: NSColor.clear, size: texture.size())

		name = "mite"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
