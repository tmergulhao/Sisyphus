//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class Scene: SKScene {

	let fontName = "Computer Pixel-7"

	var entities : Array<GKEntity> = [GKEntity]()
	var graphs : Dictionary<String, GKGraph> = [String : GKGraph]()

	var spaceBar : SKSpriteNode?
	var arrowUp : SKSpriteNode?
	var arrowDown : SKSpriteNode?
	var arrowRight : SKSpriteNode?
	var arrowLeft : SKSpriteNode?

	func enlargeKey (_ directional : Directional) {
		let upscale : SKAction = SKAction.scale(to: 1.5, duration: 0.2)
		let visible : SKAction = SKAction.fadeAlpha(to: 1, duration: 0.2)

		let compound : SKAction = SKAction.sequence([upscale, visible])

		switch directional {
		case Directional.up: arrowUp?.run(compound)
		case Directional.down: arrowDown?.run(compound)
		case Directional.right: arrowRight?.run(compound)
		case Directional.left: arrowLeft?.run(compound)
		default: break
		}
	}

	func enlargeKey (_ action : Action) {
		let upscale : SKAction = SKAction.scale(to: 1.5, duration: 0.2)
		let visible : SKAction = SKAction.fadeAlpha(to: 1, duration: 0.2)

		let compound : SKAction = SKAction.sequence([upscale, visible])

		switch action {
		case Action.primary: spaceBar?.run(compound)
		case Action.secondary: break
		default: break
		}
	}

	func retractKey (_ directional : Directional) {
		let downscale : SKAction = SKAction.scale(to: 1, duration: 0.2)
		let transparent : SKAction = SKAction.fadeAlpha(to: 0.3, duration: 0.2)

		let compound : SKAction = SKAction.sequence([downscale, transparent])

		switch directional {
		case Directional.up: arrowUp?.run(compound)
		case Directional.down: arrowDown?.run(compound)
		case Directional.right: arrowRight?.run(compound)
		case Directional.left: arrowLeft?.run(compound)
		default: break
		}
	}

	func retractKey (_ action : Action) {
		let downscale : SKAction = SKAction.scale(to: 1, duration: 0.2)
		let transparent : SKAction = SKAction.fadeAlpha(to: 0.3, duration: 0.2)

		let compound : SKAction = SKAction.sequence([downscale, transparent])

		switch action {
		case Action.primary: spaceBar?.run(compound)
		case Action.secondary: break
		default: break
		}
	}

	func onScreenControls (directional : Directional, action : Action) {
		let atlas = SKTextureAtlas(named: "Controls")
		let arrowTexture = atlas.textureNamed("arrow")
		let arrowSize = CGSize(width: 40, height: 40)
		let transparent : SKAction = SKAction.fadeAlpha(to: 0.3, duration: 0)

		let arrow = SKSpriteNode(texture: arrowTexture, color: NSColor.clear, size: arrowSize)

		if directional.contains(.up) {
			arrowUp = arrow.copy() as? SKSpriteNode

			arrowUp?.position = CGPoint(x: 0.45 * self.size.width - 50, y: -0.45 * self.size.height + 50)
			arrowUp?.run(transparent)

			addChild(arrowUp!)
		}

		if directional.contains(.down) {
			arrowDown = arrow.copy() as? SKSpriteNode

			arrowDown?.position = CGPoint(x: 0.45 * self.size.width - 50, y: -0.45 * self.size.height)
			arrowDown?.zRotation = CGFloat(180).radians
			arrowDown?.run(transparent)

			addChild(arrowDown!)
		}

		if directional.contains(.right) {
			arrowRight = arrow.copy() as? SKSpriteNode

			arrowRight?.position = CGPoint(x: 0.45 * self.size.width - 25, y: -0.45 * self.size.height + 25)
			arrowRight?.zRotation = CGFloat(-90).radians
			arrowRight?.run(transparent)

			addChild(arrowRight!)
		}

		if directional.contains(.left) {
			arrowLeft = arrow.copy() as? SKSpriteNode

			arrowLeft?.position = CGPoint(x: 0.45 * self.size.width - 75, y: -0.45 * self.size.height + 25)
			arrowLeft?.zRotation = CGFloat(90).radians
			arrowLeft?.run(transparent)

			addChild(arrowLeft!)
		}

		if action.contains(.primary) {
			let spaceTexture = atlas.textureNamed("space")
			let spaceSize = CGSize(width: 400, height: 40)

			spaceBar = SKSpriteNode(texture: spaceTexture, color: NSColor.clear, size: spaceSize)
			spaceBar?.position = CGPoint(x: 0, y: -0.45 * self.size.height + 25)
			spaceBar?.run(transparent)

			addChild(spaceBar!)
		}
	}
    
    override func sceneDidLoad() {}

	var previousTime : TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {

        if (previousTime == 0) {
            previousTime = currentTime
        }

		let deltaTime = previousTime - currentTime

        for entity in self.entities {
            entity.update(deltaTime: deltaTime)
        }

		previousTime = currentTime
    }

	var directional : Directional = Directional.none
	var directionalGuard : Set<Directional> = []

	var action : Action = Action.none
	var actionGuard : Set<Action> = []

	override func keyDown(with theEvent: NSEvent) {

		let keyStroke = theEvent.characters?.utf16.first ?? 0

		if let key = Directional.validate(keyStroke: keyStroke) {
			directional.insert(key)
			enlargeKey(key)
			return
		}

		if let key = Action.validate(keyStroke: keyStroke) {
			action.insert(key)
			enlargeKey(key)
			return
		}
	}

	override func keyUp(with theEvent: NSEvent) {

		let keyStroke = theEvent.characters?.utf16.first ?? 0

		if let key = Directional.validate(keyStroke: keyStroke) {
			directional.remove(key)
			directionalGuard.remove(key)
			retractKey(key)
			return
		}

		if let key = Action.validate(keyStroke: keyStroke) {
			action.remove(key)
			actionGuard.remove(key)
			retractKey(key)
			return
		}
	}

}
