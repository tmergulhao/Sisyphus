//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

typealias Degrees = CGFloat

let π = CGFloat(M_PI)

extension CGFloat {
	var radians : CGFloat { return π * self / 180.0 }
}

class GameScene : Scene {

	var cockroach : Cockroach?
	var mite : Mite?
	var fly : Fly?

	func addItems () {

		let cockroach = Cockroach()

		cockroach.position = CGPoint(x: 0, y: 0)

		self.cockroach = cockroach
		addChild(cockroach)

		let mite = Mite()

		mite.position = CGPoint(x: -0.33*frame.width, y: 0)

		self.mite = mite
		addChild(mite)

		let fly = Fly()

		fly.position = CGPoint(x: 0.33*frame.width, y: 0)

		self.fly = fly
		addChild(fly)

	}

	override func sceneDidLoad() {

		backgroundColor = NSColor.white

		addItems()
	}

	override func update(_ currentTime: TimeInterval) {

		let rand : Bool = drand48() > 0.8
		var speed : CGFloat = 60

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime

		if keys.contains(.action) {
			speed *= 2

			cockroach?.state = .action
			mite?.state = .action
			fly?.state = .action
		} else {
			cockroach?.state = .idle
			mite?.state = .idle
			fly?.state = .idle
		}

		var _angle : Degrees?

		switch keysMask & ~Keys.action.mask {
		case Keys.combine([.down, .left, .right, .up]), Keys.combine([]): break
		case Keys.combine([.left, .right, .up]), Keys.up.mask: _angle = 0
		case Keys.combine([.down, .left, .up]), Keys.left.mask: _angle = 2 * 45
		case Keys.combine([.down, .right, .up]), Keys.right.mask: _angle = -2 * 45
		case Keys.combine([.left, .right, .down]), Keys.down.mask: _angle = -4 * 45
		case Keys.combine([.left, .up]): _angle = 1 * 45
		case Keys.combine([.left, .down]): _angle = 3 * 45
		case Keys.combine([.right, .up]): _angle = -1 * 45
		case Keys.combine([.right, .down]): _angle = -3 * 45
		default: break
		}

		if let angle = _angle {
			let time = CGFloat(deltaTime)
			let direction = CGVector(dx: speed * time * sin(angle.radians), dy: speed * time * -cos(angle.radians))

			let rotate = SKAction.rotate(toAngle: angle.radians, duration: 0.2, shortestUnitArc: rand)
			let move = SKAction.move(by: direction, duration: 0.2)
			let compound = SKAction.sequence([rotate, move])

			cockroach?.run(compound)
			mite?.run(compound)
			fly?.run(compound)
		}

		for entity in self.entities {
			entity.update(deltaTime: deltaTime)
		}

		previousTime = currentTime
	}
}
