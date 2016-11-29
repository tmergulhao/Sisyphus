//
//  Flying.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 14/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit
import AVFoundation

class FlyingState : GKState {

	unowned var action : ActionComponent

	var entity : GKEntity { return action.entity! }

	var movement : MovementComponent?
	var render : RenderComponent?

	var soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Fly buzz", ofType: "mp3")!)
	var audioPlayer = AVAudioPlayer()

	init(_ action : ActionComponent) {

		audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
		audioPlayer.prepareToPlay()

		self.action = action

		super.init()

		movement = entity.component(ofType: MovementComponent.self)
		render = entity.component(ofType: RenderComponent.self)
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {

		return true
	}

	override func didEnter(from previousState: GKState?) {

		movement?.speed = 180

		audioPlayer.play()

		let upscale = SKAction.scale(to: 1.5, duration: 0.5)

		let compount = SKAction.sequence([action.animation[self]!, upscale])

		render?.spriteNode.run(compount)
	}

	override func willExit(to nextState: GKState) {

		audioPlayer.stop()

		let downscale = SKAction.scale(to: 1, duration: 0.5)

		render?.spriteNode.run(downscale)
	}
}
