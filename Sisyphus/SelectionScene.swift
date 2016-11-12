//
//  SelectionScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum SelectionState : Int {
	case left = 0, center, right, none = 14
}

class SelectionScene : Scene {

	static var count = 0

	var label : SKLabelNode!

	static var questions : Array<Dictionary<String,AnyObject>> = {

		if  let path = Bundle.main.path(forResource: "SelectionItems", ofType: "plist"),
			let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>,
			let questions = dictionary["questions"] as? Array<Dictionary<String,AnyObject>> {

			return questions
		}

		return []

	}()

	func addLabel (forQuestion question : Dictionary<String,AnyObject>) {

		let value = question["value"] as! String

		label = SKLabelNode(fontNamed: fontName)

		label.text = value
		label.fontColor = SKColor.black
		label.fontSize = 100
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .baseline

		label.position = CGPoint(x: 0, y: frame.height/4)

		addChild(label)
	}

	var items : Array<SKSpriteNode> = []

	func addItems (forQuestion question : Dictionary<String,AnyObject>) {

		let atlasName = question["atlas"] as! String
		let imageNames = question["images"] as! Array<String>

		let atlas = SKTextureAtlas(named: atlasName)

		for index in 0...2 {
			let texture = atlas.textureNamed(imageNames[index])
			let size = CGSize(width: 128, height: 128)

			let item = SKSpriteNode(texture: texture, color: NSColor.clear, size: size)
			let position = CGPoint(x: 0.33 * CGFloat(index - 1) * frame.width, y: 0)

			item.position = position

			items.append(item)
			addChild(item)
		}
	}

	override func sceneDidLoad() {

		SelectionScene.count += 1

		backgroundColor = NSColor.white

		var questions = SelectionScene.questions
		let max : Double = Double(questions.count - 1)
		let rand : Double = floor(drand48() * max)
		let index : Int = Int(rand)

		let question : Dictionary<String,AnyObject> = questions.remove(at: index)

		addItems(forQuestion : question)

		addLabel(forQuestion : question)

		selection = .center
	}

	fileprivate var lastSelection : SelectionState = .none
	var selection : SelectionState {
		get { return lastSelection }
		set(newValue) {
			if lastSelection != newValue {
				changeSelection(from: lastSelection, to: newValue)
				lastSelection = newValue
			}
		}
	}

	func changeSelection (from before : SelectionState, to after : SelectionState) {

		let upscale = SKAction.scale(by: 2, duration: 0.5)
		let downscale = SKAction.scale(by: 0.5, duration: 0.5)

		if before != .none {
			items[before.rawValue].run(downscale)
		}

		if after != .none {
			items[after.rawValue].run(upscale)
		}
	}

	override func update(_ currentTime: TimeInterval) {

		if (previousTime == 0) {
			previousTime = currentTime
		}

		let deltaTime = previousTime - currentTime
		switch keysMask & ~Keys.combine([.down, .up]) {
		case Keys.combine([.left, .right]), Keys.combine([]): break
		case Keys.right.mask where !keyGuard.contains(.right):
			keyGuard.insert(.right)
			if let newSelection = SelectionState(rawValue: selection.rawValue + 1) {
				selection = newSelection
			}
			break
		case Keys.left.mask where !keyGuard.contains(.left):
			keyGuard.insert(.left)
			if let newSelection = SelectionState(rawValue: selection.rawValue - 1) {
				selection = newSelection
			}
			break
		default: break
		}

		if keys.contains(.action) {

			let transition = SKTransition.crossFade(withDuration: 0)

			let scene = SelectionScene.count > 3 ? GameScene(size: size) : SelectionScene(size: size)

			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			transition.pausesOutgoingScene = false

			view?.presentScene(scene, transition: transition)
		}

		for entity in self.entities {
			entity.update(deltaTime: deltaTime)
		}
		
		previousTime = currentTime
	}
}
