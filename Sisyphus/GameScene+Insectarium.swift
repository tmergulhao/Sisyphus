//
//  GameScene+Insectarium.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 21/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

extension GameScene {

	func randomInsect () -> GKEntity {

		let distributionForInsect = GKRandomDistribution(lowestValue: 0, highestValue: 2)

		let index = distributionForInsect.nextInt()

		switch index {
		case 0: return MiteEntity()
		case 1: return FlyEntity()
		case 2: fallthrough
		default: return CockroachEntity()
		}
	}

	func setupInsectarium () {

		let frame : (xMax : Int, yMax : Int) = (Int(size.width)/2, Int(size.height)/2)

		let randomSource = GKMersenneTwisterRandomSource()

		let xDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: -frame.xMax, highestValue: frame.xMax)
		let yDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: -frame.yMax, highestValue: frame.yMax)

		let zRotationDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 359)

		for _ in 0...20 {

			let insect = randomInsect()

			entities.append(insect)

			guard let node = insect.component(ofType: RenderComponent.self)?.spriteNode else {
				fatalError("No sprite node on RenderComponent")
			}

			let position = CGPoint(
				x: xDistribution.nextInt(),
				y: yDistribution.nextInt()
			)

			let rotation = CGFloat(zRotationDistribution.nextInt()).radians

			node.position = position
			node.zRotation = rotation
			
			addChild(node)
		}
	}
}
