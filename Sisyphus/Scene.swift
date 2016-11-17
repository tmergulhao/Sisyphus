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

	var entities : Array<GKEntity> = [GKEntity]()
	var graphs : Dictionary<String, GKGraph> = [String : GKGraph]()

	let fontName = "Computer Pixel-7"

	var directional : Directional = Directional.none
	var directionalGuard : Set<Directional> = []

	var action : Action = Action.none
	var actionGuard : Set<Action> = []

	override func keyDown(with theEvent: NSEvent) {

		let keyStroke = theEvent.characters?.utf16.first ?? 0

		if let key = Directional.validate(keyStroke: keyStroke) {

			if directional.contains(key) {
				directionalGuard.insert(key)
			}
			directional.insert(key)
			enlargeKey(key)
			return
		}

		if let key = Action.validate(keyStroke: keyStroke) {

			if action.contains(key) {
				actionGuard.insert(key)
			}
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

	// MARK - OnScreenControls

	var spaceBar : SKSpriteNode?
	var arrowUp : SKSpriteNode?
	var arrowDown : SKSpriteNode?
	var arrowRight : SKSpriteNode?
	var arrowLeft : SKSpriteNode?
}
