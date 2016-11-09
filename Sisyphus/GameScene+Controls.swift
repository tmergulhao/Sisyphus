//
//  GameScene+Controls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 09/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum GameKeys : String {
	case left = "leftKey"
	case right = "rightKey"
	case jump = "jumpKey"
	case run = "runKey"
}

extension UInt16 : ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value : UnicodeScalar) {
		self = UInt16(value.value)
	}
}

extension GameScene {

	override func keyDown(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		if theEvent.modifierFlags.contains(.shift) {
			keysPressed.insert(GameKeys.run)
		}

		switch key {
		case UInt16(NSRightArrowFunctionKey):
			keysPressed.insert(GameKeys.right)
		case UInt16(NSLeftArrowFunctionKey):
			keysPressed.insert(GameKeys.left)
		case "r":
			keysPressed.insert(GameKeys.run)
		case UInt16(NSUpArrowFunctionKey):
			keysPressed.insert(GameKeys.jump)
		default:
			break
		}

		super.keyDown(with: theEvent)
	}

	override func keyUp(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		if theEvent.modifierFlags.contains(.shift) {
			keysPressed.remove(GameKeys.run)
		}

		switch key {
		case UInt16(NSRightArrowFunctionKey):
			keysPressed.remove(GameKeys.right)
		case UInt16(NSLeftArrowFunctionKey):
			keysPressed.remove(GameKeys.left)
		case "r":
			keysPressed.remove(GameKeys.run)
		case UInt16(NSUpArrowFunctionKey):
			keysPressed.remove(GameKeys.jump)
		default:
			break
		}

		super.keyUp(with: theEvent)
	}
}
