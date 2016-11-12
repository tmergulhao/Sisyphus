//
//  GameScene+Controls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 09/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum GameKeys {
	case left
	case right
	case action
	case run

	init? (rawValue : UInt16) {
		switch rawValue {
		case " ":
			self = .action
		case "r":
			self = .run
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

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = GameKeys(rawValue: key) else { return }

		keys.insert(validKey)
	}

	override func keyUp(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = GameKeys(rawValue: key) else { return }

		keys.remove(validKey)
	}

}

//		if theEvent.modifierFlags.contains(.shift) {
//			keys.insert(GameKeys.run)
//		}
//		switch event.keyCode {
//		case 0x31:
//			if let label = self.label {
//				label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//			}
//		default:
//
//		}
