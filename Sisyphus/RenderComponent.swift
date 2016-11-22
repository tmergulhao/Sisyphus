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

	static func animation(textureHandle : String, numberOfTextures : Int, atlasName : String, timePerFrame : TimeInterval) -> SKAction {

		let atlas : SKTextureAtlas = atlasses[atlasName] ?? SKTextureAtlas(named: atlasName)

		atlasses[atlasName] = atlas

		let textures : Array<SKTexture> = (1...numberOfTextures).map { atlas.textureNamed(textureHandle + String($0)) }

		let randomSource = GKMersenneTwisterRandomSource()

		let shuffledTextures : Array<SKTexture> = randomSource.arrayByShufflingObjects(in: textures) as! Array<SKTexture>

		let action =  SKAction.animate(with: shuffledTextures, timePerFrame: timePerFrame)

		return SKAction.repeatForever(action)
	}

	var spriteNode : SKSpriteNode!

	var size : CGSize!

	override func didAddToEntity() {

		spriteNode = SKSpriteNode(color: .clear, size: size)

		spriteNode.entity = entity
	}

	override func willRemoveFromEntity() {

		spriteNode.entity = nil
	}
}
