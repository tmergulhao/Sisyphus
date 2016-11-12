//
//  Fly.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum FlyState {
	case none
	case flying
	case idle
}

class Fly : SKSpriteNode {

	fileprivate static let atlas = { return SKTextureAtlas(named: "fly") }()

	fileprivate static let idle : SKAction = {
		let textures = (1...3).map { atlas.textureNamed("idle_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate static let flying : SKAction = {
		let textures = (1...2).map { atlas.textureNamed("flying_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate var lastState : FlyState = .none
	var state : FlyState = .idle {
		didSet {
			if lastState != state {
				lastState = state
				removeAllActions()

				switch state {
				case .flying: run(Fly.flying)
				case .idle: run(Fly.idle)
				default: break
				}
			}
		}
	}

	init () {
		let texture = Fly.atlas.textureNamed("idle_1")

		super.init(texture: nil, color: NSColor.clear, size: texture.size())

		name = "fly"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
