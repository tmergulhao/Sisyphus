//
//  GameScene+Insectarium.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 21/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

extension Scene {

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

		let frame : (xMax : Int, yMax : Int) = (500, 500)

		let randomSource = GKMersenneTwisterRandomSource()

		let xDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: -frame.xMax, highestValue: frame.xMax)
		let yDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: -frame.yMax, highestValue: frame.yMax)

		let zRotationDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 359)

		var cockroaches : Array<CockroachEntity> = []
		var flys : Array<FlyEntity> = []
		var mites : Array<MiteEntity> = []

		for _ in 0...20 {

			let insect = randomInsect()

			guard let node = insect.component(ofType: RenderComponent.self)?.spriteNode else {
				fatalError("No sprite node on RenderComponent")
			}

			entitiesNode.addChild(node)

			let position = CGPoint(
				x: xDistribution.nextInt(),
				y: yDistribution.nextInt()
			)

			let rotation = CGFloat(zRotationDistribution.nextInt()).radians

			node.position = position
			node.zRotation = rotation

			let agent = GKAgent2D()

			agent.radius = (Float(node.frame.width)/2)
			agent.maxAcceleration = 100
			agent.maxSpeed = 100
			agent.mass = 0.01
			agent.rotation = Float(rotation)

			agent.delegate = insect

			insect.addComponent(agent)

			entities.append(insect)

			switch insect {
			case is CockroachEntity: cockroaches.append(insect as! CockroachEntity)
			case is FlyEntity: flys.append(insect as! FlyEntity)
			case is MiteEntity: mites.append(insect as! MiteEntity)
			default: break
			}
		}

		let cockroachAgents = cockroaches.map { $0.component(ofType: GKAgent2D.self)! }
		let flyAgents = flys.map { $0.component(ofType: GKAgent2D.self)! }
		let miteAgents = mites.map { $0.component(ofType: GKAgent2D.self)! }

		cockroachAgents.forEach {

			$0.behavior  = GKBehavior(goals: [
				GKGoal(toAvoid: obstacles, maxPredictionTime: 1),
				GKGoal(toAlignWith: cockroachAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toCohereWith: cockroachAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toSeparateFrom: cockroachAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toWander: 100),
			])
		}

		flyAgents.forEach {

			$0.behavior = GKBehavior(goals: [
				GKGoal(toAvoid: obstacles, maxPredictionTime: 1),
				GKGoal(toAlignWith: flyAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toCohereWith: flyAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toSeparateFrom: flyAgents, maxDistance: 50, maxAngle: .pi/4),
				GKGoal(toWander: 100),
			])
		}

		miteAgents.forEach {

			$0.behavior  = GKBehavior(goals: [
				GKGoal(toAvoid: obstacles, maxPredictionTime: 1),
				GKGoal(toAlignWith: miteAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toCohereWith: miteAgents, maxDistance: 10, maxAngle: .pi/4),
				GKGoal(toSeparateFrom: miteAgents, maxDistance: 100, maxAngle: .pi/4),
				GKGoal(toWander: 100),
			])
		}
	}
}
