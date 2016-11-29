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

	var label : SKLabelNode!

	override func sceneDidLoad() {

		super.sceneDidLoad()

		onScreenControls(directional: [], action: [.primary])

		let disappear = SKAction.fadeAlpha(to: 0, duration: 0.5)
		let appear = SKAction.fadeAlpha(to: 1, duration: 0.5)
		let disappearAndAppear = SKAction.sequence([disappear, appear])
		let blink = SKAction.repeatForever(disappearAndAppear)

		label = SKLabelNode(fontNamed: fontName)

		label.text = "press space to start"
		label.fontColor = .black
		label.fontSize = 70
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .baseline
		label.position = CGPoint(x: 0, y: -frame.height/4)

		label.run(blink)

		addChild(label)
	}

	override func update(_ currentTime: TimeInterval) {

		if action.contains(.primary) && !actionGuard.contains(.primary) {

			label.removeAllActions()

			let disappear = SKAction.fadeAlpha(to: 0, duration: 0.2)
			let appear = SKAction.fadeAlpha(to: 1, duration: 0.2)
			let disappearAndAppear = SKAction.sequence([disappear, appear])
			let blinkFast = SKAction.repeatForever(disappearAndAppear)

			label.run(blinkFast)

			let transition = SKTransition.crossFade(withDuration: 0.5)

			transition.pausesOutgoingScene = false

			guard let scene = GKScene(fileNamed: "Selection") else { fatalError("No scene file on bundle") }

			guard let sceneNode = scene.rootNode as? SelectionScene else { fatalError("Scene node does not match given class") }

			sceneNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			sceneNode.actionGuard = actionGuard

			sceneNode.entities = scene.entities
			sceneNode.graphs = scene.graphs

			sceneNode.scaleMode = .aspectFill

			view?.presentScene(sceneNode, transition: transition)
		}

		super.update(currentTime)
	}
}
