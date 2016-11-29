//
//  TitleScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class TitleScene : Scene {

	var pressSpace : SKLabelNode! { return childNode(withName: "Press space to start") as? SKLabelNode }

	override func sceneDidLoad() {

		super.sceneDidLoad()

		onScreenControls(directional: [], action: [.primary])

		pressSpace.fontName = fontName
	}

	override func update(_ currentTime: TimeInterval) {

		if action.contains(.primary) && !actionGuard.contains(.primary) {

			let transition = SKTransition.crossFade(withDuration: 0.5)

			transition.pausesOutgoingScene = false

			guard let scene = GKScene(fileNamed: "Selection") else { fatalError("No scene file on bundle") }

			guard let sceneNode = scene.rootNode as? SelectionScene else { fatalError("Scene node does not match given class") }

			sceneNode.actionGuard = actionGuard

			sceneNode.entities = scene.entities
			sceneNode.graphs = scene.graphs

			sceneNode.scaleMode = .aspectFill

			view?.presentScene(sceneNode, transition: transition)
		}

		super.update(currentTime)
	}
}
