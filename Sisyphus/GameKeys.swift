//
//  GameScene+Controls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 09/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum GameKeys : String {
	case left
	case right
	case jump = " "
	case run = "r"

	init? (_ rawValue : UInt16) {
		switch rawValue {
		case UInt16(NSRightArrowFunctionKey):
			self = .right
		case UInt16(NSLeftArrowFunctionKey):
			self = .left
		default:
			return nil
		}
	}
}

extension UInt16 : ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value : UnicodeScalar) {
		self = UInt16(value.value)
	}
}

extension GameScene {

	override func keyDown(with theEvent: NSEvent) {

		Swift.print("keyDown: \(theEvent.characters!) keyCode: \(theEvent.keyCode)")

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = GameKeys(key) else { return }

		keys.insert(validKey)

		super.keyDown(with: theEvent)
	}

	override func keyUp(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = GameKeys(key) else { return }

		keys.remove(validKey)

		super.keyUp(with: theEvent)
	}

}

