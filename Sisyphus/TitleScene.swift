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

		backgroundColor = NSColor.white

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

		super.sceneDidLoad()
	}

	override func update(_ currentTime: TimeInterval) {

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime

		if keys.contains(.action) && !keyGuard.contains(.action) {
			keyGuard.insert(.action)

			label.removeAllActions()

			let disappear = SKAction.fadeAlpha(to: 0, duration: 0.2)
			let appear = SKAction.fadeAlpha(to: 1, duration: 0.2)
			let disappearAndAppear = SKAction.sequence([disappear, appear])
			let blinkFast = SKAction.repeatForever(disappearAndAppear)

			label.run(blinkFast)

			let transition = SKTransition.crossFade(withDuration: 0.5)

			let scene = SelectionScene(size: size)

			scene.keyGuard = keyGuard
			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			transition.pausesOutgoingScene = false

			view?.presentScene(scene, transition: transition)
		}

		for entity in self.entities {
			entity.update(deltaTime: deltaTime)
		}
		
		previousTime = currentTime
	}
}
