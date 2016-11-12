//
//  GameScene+Controls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 09/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

enum Keys : UInt16 {
	case left = 0, right = 1, up = 2, down = 3, action = 4, run = 5, none = 14

	var mask : UInt16 {
		return 1 << rawValue
	}

	static func combine (_ elements : Array<Keys>) -> UInt16 {
		return elements
			.map { 1 << $0.rawValue }
			.reduce(0) { $0 | $1 }
	}

	static func validate (rawValue : UInt16) -> Keys? {
		switch rawValue {
		case " ": return .action
		case "r": return .run
		case UInt16(NSRightArrowFunctionKey): return .right
		case UInt16(NSLeftArrowFunctionKey): return .left
		case UInt16(NSDownArrowFunctionKey): return .down
		case UInt16(NSUpArrowFunctionKey): return .up
		default: return nil
		}
	}
}

extension UInt16 : ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value : UnicodeScalar) {
		self = UInt16(value.value)
	}
}
