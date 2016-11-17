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

	static var questions : Array<Dictionary<String,AnyObject>> = {

		guard let path = Bundle.main.path(forResource: "SelectionItems", ofType: "plist"),
			let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>,
			let questions = dictionary["questions"] as? Array<Dictionary<String,AnyObject>> else {
			fatalError("Bundle.main.path(forResource: \"SelectionItems\", ofType: \"plist\")")
		}

		return questions
	}()

	func addLabel (forQuestion question : Dictionary<String,AnyObject>) {

		let value = question["value"] as! String

		let label = SKLabelNode(fontNamed: fontName)

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

	var count = 0

	override func sceneDidLoad() {

		onScreenControls(directional: [.left, .right], action: [.primary])

		let count = SelectionScene.questions.count
		let index = Int(arc4random_uniform(UInt32(count)))

		let question : Dictionary<String,AnyObject> = SelectionScene.questions.remove(at: index)

		addItems(forQuestion : question)

		addLabel(forQuestion : question)

		selection = .center

		super.sceneDidLoad()
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

		if before != .none { items[before.rawValue].run(downscale) }

		if after != .none { items[after.rawValue].run(upscale) }
	}

	override func update(_ currentTime: TimeInterval) {

		if (directional.contains(.right), directionalGuard.contains(.right)) == (true,false) {

			if let newSelection = SelectionState(rawValue: selection.rawValue + 1) {
				selection = newSelection
			}
		}

		if (directional.contains(.left), directionalGuard.contains(.left)) == (true,false) {

			if let newSelection = SelectionState(rawValue: selection.rawValue - 1) {
				selection = newSelection
			}
		}

		if action.contains(.primary) && !actionGuard.contains(.primary) {

			let transition = SKTransition.crossFade(withDuration: 1)

			let scene : Scene!

			if count > 2 {

				scene = GameScene(size: size)
			} else {

				scene = SelectionScene(size: size)

				(scene as! SelectionScene).count = count + 1
			}

			scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			scene.actionGuard = actionGuard

			transition.pausesOutgoingScene = false

			view?.presentScene(scene, transition: transition)
		}

		super.update(currentTime)
	}
}
