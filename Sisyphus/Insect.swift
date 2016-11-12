//
//  Insect.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum InsectState {
	case none
	case action
	case moving
	case idle
}

class Insect : SKSpriteNode {

	static var atlasses : Dictionary<String,SKTextureAtlas> = [:]

	static var atlas = { return SKTextureAtlas(named: className()) }()

	init () {
		let size = CGSize(width: 128, height: 128)
		super.init(texture: nil, color: NSColor.clear, size: size)
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

	fileprivate var lastState : InsectState = .none
	var state : InsectState {
		get { return lastState }
		set(newValue) {
			if lastState != newValue {
				changeState(from: lastState, to: newValue)
				lastState = newValue
			}
		}
	}

	func act(onDirectional directional : Directional, directionalGuard : Set<Directional>, action : Action, actionGuard : Set<Action>, interval : TimeInterval) {

		let rand : Bool = drand48() > 0.8
		var speed : CGFloat = 60

		if action.contains(.primary) {
			speed *= 3

			state = .action
		} else {
			state = .idle
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
			let time = CGFloat(interval)
			let direction = CGVector(dx: speed * time * sin(angle.radians), dy: speed * time * -cos(angle.radians))

			let rotate = SKAction.rotate(toAngle: angle.radians, duration: 0.2, shortestUnitArc: rand)
			let move = SKAction.move(by: direction, duration: 0.2)
			let compound = SKAction.sequence([rotate, move])

			run(compound)
		}
	}

	func changeState (from before : InsectState, to after : InsectState) {}
}
