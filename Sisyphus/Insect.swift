//
//  Insect.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum InsectState {
	case none
	case action
	case moving
	case idle
}

class Insect : SKSpriteNode {

	static var atlasses : Dictionary<String,SKTextureAtlas> = [:]

	static var atlas = { return SKTextureAtlas(named: className()) }()

	init () {
		let size = CGSize(width: 128, height: 128)
		super.init(texture: nil, color: NSColor.clear, size: size)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static func animation(with textureHandle : String, numberOfTextures : Int, atlasName : String, timePerFrame : TimeInterval) -> SKAction {
		let atlas : SKTextureAtlas = atlasses[atlasName] ?? SKTextureAtlas(named: atlasName)

		atlasses[atlasName] = atlas

		let textures = (1...numberOfTextures).map { atlas.textureNamed(textureHandle + String($0)) }

		let action =  SKAction.animate(with: textures, timePerFrame: timePerFrame)

		return SKAction.repeatForever(action)
	}

	fileprivate var lastState : InsectState = .none
	var state : InsectState {
		get { return lastState }
		set(newValue) {
			if lastState != newValue {
				changeState(from: lastState, to: newValue)
				lastState = newValue
			}
		}
	}


	func changeState (from before : InsectState, to after : InsectState) {}
}
