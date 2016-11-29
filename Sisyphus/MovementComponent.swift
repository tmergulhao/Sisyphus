//
//  MovementComponent.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent : GKComponent {

	@GKInspectable var speed : CGFloat = 60

	var directional : Directional = .none
	var directionalGuard : Directional = .none

	var movementAngle : Degrees? {

		switch directional {
		case Directional.up :			return 0
		case Directional.down :			return -4 * 45
		case Directional.left :			return 2 * 45
		case Directional.right :		return -2 * 45
		case Directional.upLeft :		return 1 * 45
		case Directional.upRight :		return -1 * 45
		case Directional.downLeft :		return 3 * 45
		case Directional.downRight :	return -3 * 45
		default :						return nil
		}
	}

	override func update(deltaTime seconds: TimeInterval) {

		let rand : Bool = drand48() > 0.8
		let time = CGFloat(seconds)

		guard let angle = movementAngle else { return }

		let rotate = SKAction.rotate(toAngle: angle.radians, duration: 0.2, shortestUnitArc: rand)
		let displacement = CGVector(dx: speed * time * sin(angle.radians), dy: speed * time * -cos(angle.radians))
		let move = SKAction.move(by: displacement, duration: 0.2)
		let compound = SKAction.sequence([rotate, move])

		guard let render = entity!.component(ofType: RenderComponent.self) else {
			fatalError("guard let render = entity!.component(ofType: RenderComponent.self)")
		}

		render.spriteNode.run(compound)
	}
}
