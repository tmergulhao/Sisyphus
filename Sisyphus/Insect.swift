//
//  Insect.swift
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

class Insect : SKSpriteNode {

	var idle : SKAction { return SKAction() }
	var action : SKAction { return SKAction() }

	static var atlasses : Dictionary<String,SKTextureAtlas> = [:]

	static var atlas = { return SKTextureAtlas(named: className()) }()

	static func randomInsect () -> Insect {

		let index = Int(arc4random_uniform(UInt32(3)))

		switch index {
		case 0:
			return Cockroach()
		case 1:
			return Mite()
		case 2:
			fallthrough
		default:
			return Fly()
		}
	}

	var states : GKStateMachine!

	init () {
		let size = CGSize(width: 128, height: 128)
		super.init(texture: nil, color: NSColor.black, size: size)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static func animation(with textureHandle : String, numberOfTextures : Int, atlasName : String, timePerFrame : TimeInterval) -> SKAction {
		let atlas : SKTextureAtlas = atlasses[atlasName] ?? SKTextureAtlas(named: atlasName)

		atlasses[atlasName] = atlas

		let textures = (1...numberOfTextures).map { atlas.textureNamed(textureHandle + String($0)) }

		let action =  SKAction.animate(with: textures, timePerFrame: timePerFrame)

		return SKAction.repeatForever(action)
	}

	var isActing : Bool = false
	var movementSpeed : CGFloat = 60

	func act(onDirectional directional : Directional, directionalGuard : Set<Directional>, action : Action, actionGuard : Set<Action>, interval : TimeInterval) {

		if action.contains(.primary) {
			isActing = true
		} else {
			isActing = false
		}

		var _angle : Degrees?

		switch directional {
		case Directional.up :			_angle = 0
		case Directional.down :			_angle = -4 * 45
		case Directional.left :			_angle = 2 * 45
		case Directional.right :		_angle = -2 * 45
		case Directional.upLeft :		_angle = 1 * 45
		case Directional.upRight :		_angle = -1 * 45
		case Directional.downLeft :		_angle = 3 * 45
		case Directional.downRight :	_angle = -3 * 45
		default : break
		}

		if let angle = _angle {
			let rand : Bool = drand48() > 0.8
			let time = CGFloat(interval)
			let direction = CGVector(dx: movementSpeed * time * sin(angle.radians), dy: movementSpeed * time * -cos(angle.radians))

			let rotate = SKAction.rotate(toAngle: angle.radians, duration: 0.2, shortestUnitArc: rand)
			let move = SKAction.move(by: direction, duration: 0.2)
			let compound = SKAction.sequence([rotate, move])

			run(compound)
		}
	}
}
