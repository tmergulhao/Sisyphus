//
//  Scene+OnScreenControls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 16/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

extension Scene {

	var controls : SKNode! { return camera.childNode(withName: "Controls")?.children[0] }

	var leftArrow : SKSpriteNode! {		return controls.childNode(withName: "Left arrow") as? SKSpriteNode }
	var upArrow : SKSpriteNode! {		return controls.childNode(withName: "Up arrow") as? SKSpriteNode }
	var rightArrow : SKSpriteNode! {	return controls.childNode(withName: "Right arrow") as? SKSpriteNode }
	var downArrow : SKSpriteNode! {		return controls.childNode(withName: "Down arrow") as? SKSpriteNode }

	var spaceBar : SKSpriteNode! {		return controls.childNode(withName: "Space bar") as? SKSpriteNode }

	var enlarge : SKAction {

		let upscale : SKAction = SKAction.scale(to: 1.5, duration: 0.2)
		let visible : SKAction = SKAction.fadeAlpha(to: 1, duration: 0.2)

		return SKAction.sequence([upscale, visible])
	}

	func enlargeKey (_ directional : Directional) {
		switch directional {
		case Directional.up: upArrow.run(enlarge)
		case Directional.down: downArrow.run(enlarge)
		case Directional.right: rightArrow.run(enlarge)
		case Directional.left: leftArrow.run(enlarge)
		default: break
		}
	}

	func enlargeKey (_ action : Action) {
		switch action {
		case Action.primary: spaceBar.run(enlarge)
		case Action.secondary: break
		default: break
		}
	}

	var retract : SKAction {

		let downscale : SKAction = SKAction.scale(to: 1, duration: 0.2)
		let transparent : SKAction = SKAction.fadeAlpha(to: 0.3, duration: 0.2)

		return SKAction.sequence([downscale, transparent])
	}

	func retractKey (_ directional : Directional) {
		switch directional {
		case Directional.up: upArrow.run(retract)
		case Directional.down: downArrow.run(retract)
		case Directional.right: rightArrow.run(retract)
		case Directional.left: leftArrow.run(retract)
		default: break
		}
	}

	func retractKey (_ action : Action) {
		switch action {
		case Action.primary: spaceBar.run(retract)
		case Action.secondary: break
		default: break
		}
	}

	func onScreenControls (directional : Directional, action : Action) {

		let transparent : SKAction = SKAction.fadeAlpha(to: 0.3, duration: 0)

		upArrow.isHidden = !directional.contains(.up)
		downArrow.isHidden = !directional.contains(.down)
		rightArrow.isHidden = !directional.contains(.right)
		leftArrow.isHidden = !directional.contains(.left)
		spaceBar.isHidden = !action.contains(.primary)

		controls.children.forEach { $0.run(transparent) }
	}
}
