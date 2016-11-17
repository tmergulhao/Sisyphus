//
//  TitleScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

class TitleScene : Scene {

	static var count = 0

	var label : SKLabelNode!

	override func sceneDidLoad() {

		onScreenControls(directional: [], action: [.primary])

		let disappear = SKAction.fadeAlpha(to: 0, duration: 0.5)
		let appear = SKAction.fadeAlpha(to: 1, duration: 0.5)
		let disappearAndAppear = SKAction.sequence([disappear, appear])
		let blink = SKAction.repeatForever(disappearAndAppear)

		label = SKLabelNode(fontNamed: fontName)

		label.text = "press space to start"
		label.fontColor = SKColor.black
		label.fontSize = 70
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .baseline

		label.position = CGPoint(x: 0, y: -frame.height/4)

		label.run(blink)

		addChild(label)
	}

	override func update(_ currentTime: TimeInterval) {

		if action.contains(.primary) && !actionGuard.contains(.primary) {
			actionGuard.insert(.primary)

			label.removeAllActions()

			let disappear = SKAction.fadeAlpha(to: 0, duration: 0.2)
			let appear = SKAction.fadeAlpha(to: 1, duration: 0.2)
			let disappearAndAppear = SKAction.sequence([disappear, appear])
			let blinkFast = SKAction.repeatForever(disappearAndAppear)

			label.run(blinkFast)

			let transition = SKTransition.crossFade(withDuration: 0.5)

			let scene = SelectionScene(size: size)

			scene.actionGuard = actionGuard
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			transition.pausesOutgoingScene = false

			view?.presentScene(scene, transition: transition)
		}
	}
}
