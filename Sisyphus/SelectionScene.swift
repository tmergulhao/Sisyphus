//
//  SelectionScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 12/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

enum SelectionState : Int {
	case left = 0, center, right, none = 14
}

class SelectionScene : Scene {

	var labelNode : SKLabelNode! { return childNode(withName: "Label") as? SKLabelNode }

	var centerNode : SKNode! { return childNode(withName: "Center") }
	var leftNode : SKNode! { return childNode(withName: "Left") }
	var rightNode : SKNode! { return childNode(withName: "Right") }

	static var questions : Array<Dictionary<String,AnyObject>> = {

		guard let path = Bundle.main.path(forResource: "SelectionItems", ofType: "plist"),
			let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject>,
			let questions = dictionary["questions"] as? Array<Dictionary<String,AnyObject>> else {
			fatalError("Bundle.main.path(forResource: \"SelectionItems\", ofType: \"plist\")")
		}

		return questions
	}()

	var items : Array<SKNode> {

		return [leftNode, centerNode, rightNode]
	}

	func addItems (forQuestion question : Dictionary<String,AnyObject>) {

		items.forEach({ $0.removeAllChildren() })

		let atlasName = question["atlas"] as! String
		let imageNames = question["images"] as! Array<String>

		let atlas = SKTextureAtlas(named: atlasName)

		for index in 0...2 {

			let texture = atlas.textureNamed(imageNames[index])
			let size = CGSize(width: 128, height: 128)

			let item = SKSpriteNode(texture: texture, color: NSColor.clear, size: size)

			switch index {
			case 0:
				leftNode.addChild(item)
			case 1:
				centerNode.addChild(item)
			case 2:
				rightNode.addChild(item)
			default: break
			}
		}
	}

	var count = 0

	override func sceneDidLoad() {

		onScreenControls(directional: [.left, .right], action: [.primary])

		let count = SelectionScene.questions.count
		let index = Int(arc4random_uniform(UInt32(count)))

		let question : Dictionary<String,AnyObject> = SelectionScene.questions.remove(at: index)

		addItems(forQuestion : question)

		let value = question["value"] as! String

		labelNode.fontName = fontName
		labelNode.text = value

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

			transitionToNextSelection()
		}

		super.update(currentTime)
	}

	func transitionToNextSelection () {

		let transition = SKTransition.crossFade(withDuration: 1)

		transition.pausesOutgoingScene = false

		var scene : GKScene!
		var sceneNode : Scene!

		if count > 1 {

			scene = GKScene(fileNamed: "Game")

			let gameSceneNode = scene.rootNode as! GameScene

			sceneNode = gameSceneNode
		} else {

			scene = GKScene(fileNamed: "Selection")

			let selectionSceneNode = scene.rootNode as! SelectionScene

			selectionSceneNode.count = count + 1

			sceneNode = selectionSceneNode
		}

		sceneNode.actionGuard = actionGuard

		sceneNode.scaleMode = .aspectFill

		view?.presentScene(sceneNode, transition: transition)
	}
}
