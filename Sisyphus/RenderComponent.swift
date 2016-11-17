//
//  RenderComponent.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit
import SpriteKit

class RenderComponent : GKComponent {

	static var atlasses : Dictionary<String,SKTextureAtlas> = [:]

	static var atlas = { return SKTextureAtlas(named: className()) }()

	static func animation(with textureHandle : String, numberOfTextures : Int, atlasName : String, timePerFrame : TimeInterval) -> SKAction {

		let atlas : SKTextureAtlas = atlasses[atlasName] ?? SKTextureAtlas(named: atlasName)

		atlasses[atlasName] = atlas

		let textures = (1...numberOfTextures).map { atlas.textureNamed(textureHandle + String($0)) }

		let action =  SKAction.animate(with: textures, timePerFrame: timePerFrame)

		return SKAction.repeatForever(action)
	}

	var spriteNode : SKSpriteNode!

	override func didAddToEntity() {

		let size = CGSize(width: 128, height: 128)

		spriteNode = SKSpriteNode(color: .clear, size: size)

		spriteNode.position = CGPoint(x: 0, y: 0)

		spriteNode.entity = entity
	}

	override func willRemoveFromEntity() {

		spriteNode.entity = nil
	}
}
