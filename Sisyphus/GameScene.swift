//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

typealias Degrees = CGFloat

let π = CGFloat(M_PI)

extension CGFloat {
	var radians : CGFloat {
		return π * self / 180.0
	}
}

class GameScene: SKScene {

	let fontName = "Computer Pixel-7"

	var keys : Set<GameKeys> = []
	var keysMask : UInt16 = 0

	var entities : Array<GKEntity> = [GKEntity]()
	var graphs : Dictionary<String, GKGraph> = [String : GKGraph]()

    var label : SKLabelNode?

	var cockroach : Cockroach?
	var mite : Mite?
	var fly : Fly?

	func addItems () {

		let cockroach = Cockroach()

		cockroach.position = CGPoint(x: 0, y: 0)

		self.cockroach = cockroach
		addChild(cockroach)

		let mite = Mite()

		mite.position = CGPoint(x: -0.33*frame.width, y: 0)

		self.mite = mite
		addChild(mite)

		let fly = Fly()

		fly.position = CGPoint(x: 0.33*frame.width, y: 0)

		self.fly = fly
		addChild(fly)

	}
    
    override func sceneDidLoad() {

		backgroundColor = NSColor.white

		addItems()

		let label = SKLabelNode(fontNamed: fontName)

		label.text = ""
		label.fontColor = SKColor.black
		label.fontSize = 100
		label.horizontalAlignmentMode = .center
		label.verticalAlignmentMode = .baseline

		label.position = CGPoint(x: 0, y: frame.height/4)

		self.label = label

		self.addChild(label)
    }

	var previousTime : TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {

		let rand : Bool = drand48() > 0.5
		var speed : CGFloat = 60

        if (previousTime == 0) {
            previousTime = currentTime
        }

		let deltaTime = previousTime - currentTime

		if keys.contains(.action) {
			speed *= 2

			label?.text = "Pressing spacebar"

			cockroach?.state = .flying
			mite?.state = .jumping
			fly?.state = .flying
		} else {
			label?.text = ""

			cockroach?.state = .idle
			mite?.state = .idle
			fly?.state = .idle
		}

		var _angle : Degrees?

		switch keysMask & ~GameKeys.action.mask {
		case GameKeys.combine([.down, .left, .right, .up]), GameKeys.combine([]): break
		case GameKeys.combine([.left, .right, .up]), GameKeys.combine([.up]): _angle = 0
		case GameKeys.combine([.down, .left, .up]), GameKeys.combine([.left]): _angle = 2 * 45
		case GameKeys.combine([.down, .right, .up]), GameKeys.combine([.right]): _angle = -2 * 45
		case GameKeys.combine([.left, .right, .down]), GameKeys.combine([.down]): _angle = -4 * 45
		case GameKeys.combine([.left, .up]): _angle = 1 * 45
		case GameKeys.combine([.left, .down]): _angle = 3 * 45
		case GameKeys.combine([.right, .up]): _angle = -1 * 45
		case GameKeys.combine([.right, .down]): _angle = -3 * 45
		default: break
		}

		if let angle = _angle {
			let time = CGFloat(deltaTime)
			let direction = CGVector(dx: speed * time * sin(angle.radians), dy: speed * time * -cos(angle.radians))

			Swift.print(sin(angle))
			Swift.print(direction)

			let rotate = SKAction.rotate(toAngle: angle.radians, duration: 0.2, shortestUnitArc: rand)
			let move = SKAction.move(by: direction, duration: 0.2)
			let compound = SKAction.sequence([rotate, move])

			cockroach?.run(compound)
			mite?.run(compound)
			fly?.run(compound)
		}

        for entity in self.entities {
            entity.update(deltaTime: deltaTime)
        }

        previousTime = currentTime
    }
}
