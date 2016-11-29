//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene : Scene {

	var player : GKEntity!

	var soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Background buzz", ofType: "wav")!)
	var audioPlayer = AVAudioPlayer()

	override func sceneDidLoad() {

		audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
		audioPlayer.prepareToPlay()

		audioPlayer.volume = 0.3

		audioPlayer.play()

		onScreenControls(directional: [.up, .down, .left, .right], action: [.primary])

		player = randomInsect()

		entities.append(player)

		guard let node = player.component(ofType: RenderComponent.self)?.spriteNode else {
			fatalError("No sprite node on RenderComponent")
		}

		entitiesNode.addChild(node)

		guard let camera : SKCameraNode = camera else { return }
		guard let playerNode : SKSpriteNode = player?.component(ofType: RenderComponent.self)?.spriteNode else { return }

		let zeroRange = SKRange(constantValue: 0.0)
		let playerLocationConstraint = SKConstraint.distance(zeroRange, to: playerNode)

		camera.constraints = [playerLocationConstraint]

		super.sceneDidLoad()
	}

	override func update(_ currentTime: TimeInterval) {

		if let movementComponent = player.component(ofType: MovementComponent.self) {

			movementComponent.directional = directional
			movementComponent.directionalGuard = directionalGuard
		}

		if let actionComponent = player.component(ofType: ActionComponent.self) {

			actionComponent.action = action
			actionComponent.actionGuard = actionGuard
		}

		super.update(currentTime)
	}

	override func mouseDown (with event: NSEvent) {

		let location = event.location(in: self)

		sceneAgent.position = vector2(Float(location.x), Float(location.y))
	}
}
