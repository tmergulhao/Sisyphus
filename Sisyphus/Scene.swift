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

	var directional : Directional = .none
	var directionalGuard : Directional = .none

	var action : Action = .none
	var actionGuard : Action = .none

	lazy var obstacles : Array<GKPolygonObstacle>! = ({

		let nodes = self.childNode(withName: "Outer walls")!.children
		return SKNode.obstacles(fromNodeBounds: nodes)
	})()

	override var camera: SKCameraNode! {

		get { return childNode(withName: "Camera") as? SKCameraNode }
		set { return }
	}

	var sceneAgent : GKAgent2D!

	override func sceneDidLoad() {

		sceneAgent = GKAgent2D()
		sceneAgent.position = vector2(0, 0)
		sceneAgent.radius = 300

		setupInsectarium()

		super.sceneDidLoad()
	}

	var previousTime : TimeInterval = 0

	override func update(_ currentTime: TimeInterval) {

		if previousTime == 0 { previousTime = currentTime }

		let deltaTime = currentTime - previousTime

		for entity in entities {

			entity.update(deltaTime: deltaTime)
		}

		previousTime = currentTime

		directionalGuard = directional
		actionGuard = action
	}

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
