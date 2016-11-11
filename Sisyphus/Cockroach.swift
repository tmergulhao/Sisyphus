//
//  Cockroach.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 11/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum CockroachState {
	case flying
	case idle
}

class Cockroach : SKSpriteNode {

	fileprivate static let idle : SKAction = {
		let textureAtlas = SKTextureAtlas(named: "cockroach")

		let textures = (0...4).map { textureAtlas.textureNamed("cockroach_\($0 + 1)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	fileprivate static let flying : SKAction = {
		let textureAtlas = SKTextureAtlas(named: "flying_cockroach")

		let textures = (0...4).map { textureAtlas.textureNamed("flying_cockroach_\($0 + 1)") }

		let action =  SKAction.animate(with: textures, timePerFrame: 0.2)

		return SKAction.repeatForever(action)
	}()

	var state : CockroachState = .idle {
		didSet {
			removeAllActions()

			switch state {
			case .flying: run(Cockroach.flying)
			case .idle: run(Cockroach.idle)
			}
		}
	}

	init () {
		let texture = SKTexture(imageNamed: "cockroach_1")

		super.init(texture: texture, color: NSColor.clear, size: texture.size())

		name = "cockroarch"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
