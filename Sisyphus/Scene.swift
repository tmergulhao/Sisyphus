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
			return
		}

		if let key = Action.validate(keyStroke: keyStroke) {
			action.insert(key)
			return
		}
	}

	override func keyUp(with theEvent: NSEvent) {

		let keyStroke = theEvent.characters?.utf16.first ?? 0

		if let key = Directional.validate(keyStroke: keyStroke) {
			directional.remove(key)
			directionalGuard.remove(key)
			return
		}

		if let key = Action.validate(keyStroke: keyStroke) {
			action.remove(key)
			actionGuard.remove(key)
			return
		}
	}

}
