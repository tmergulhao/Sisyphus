//
//  Cockroach.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum CockroachState {
	case none
	case flying
	case idle
}

class Cockroach : SKSpriteNode {

	fileprivate static let atlas = { return SKTextureAtlas(named: "cockroach") }()

	fileprivate static let idle : SKAction = {
		let textures = (1...5).map { atlas.textureNamed("idle_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate static let flying : SKAction = {
		let textures = (1...6).map { atlas.textureNamed("flying_\($0)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate var lastState : CockroachState = .none
	var state : CockroachState = .idle {
		didSet {
			if lastState != state {
				lastState = state
				removeAllActions()

				switch state {
				case .flying: run(Cockroach.flying)
				case .idle: run(Cockroach.idle)
				default: break
				}
			}
		}
	}

	init () {
		let texture = Cockroach.atlas.textureNamed("idle_1")

		super.init(texture: nil, color: NSColor.clear, size: texture.size())

		name = "cockroarch"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
