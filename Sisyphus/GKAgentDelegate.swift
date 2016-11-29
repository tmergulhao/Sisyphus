//
//  GKAgentDelegate.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 29/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import GameplayKit

extension GKEntity : GKAgentDelegate {

	public func agentWillUpdate (_ agent: GKAgent) {

		guard let node = component(ofType: RenderComponent.self)?.spriteNode else { return }
		guard let agent = agent as? GKAgent2D else { return }

		agent.position = vector2(Float(node.position.x), Float(node.position.y))
	}

	public func agentDidUpdate (_ agent: GKAgent) {

		guard let node = component(ofType: RenderComponent.self)?.spriteNode else { return }
		guard let agent = agent as? GKAgent2D else { return }

		let deltaX = CGFloat(agent.position.x) - node.position.x
		let deltaY = CGFloat(agent.position.y) - node.position.y

		let rotation = -atan2(deltaX, deltaY)

		node.position = CGPoint(x: CGFloat(agent.position.x), y: CGFloat(agent.position.y))

		node.zRotation = rotation
	}
}
