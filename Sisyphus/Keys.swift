//
//  GameScene+Controls.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 09/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit

struct Directional : OptionSet, Hashable {

	let rawValue : Int
	var hashValue: Int { return rawValue }

	static let none		= Directional(rawValue: 0)
	static let up		= Directional(rawValue: 1 << 0)
	static let down		= Directional(rawValue: 1 << 1)
	static let left		= Directional(rawValue: 1 << 2)
	static let right	= Directional(rawValue: 1 << 3)

	static let upLeft : Directional		= [.up, .left]
	static let upRight : Directional	= [.up, .right]
	static let downLeft : Directional	= [.down, .left]
	static let downRight : Directional	= [.down, .right]

	static func validate (keyStroke : UInt16) -> Directional? {
		switch keyStroke {
		case UInt16(NSRightArrowFunctionKey): return Directional.right
		case UInt16(NSLeftArrowFunctionKey): return Directional.left
		case UInt16(NSDownArrowFunctionKey): return Directional.down
		case UInt16(NSUpArrowFunctionKey): return Directional.up
		default: return nil
		}
	}

}

struct Action : OptionSet, Hashable {

	let rawValue : Int
	var hashValue: Int { return rawValue }

	static let none			= Action(rawValue: 0)
	static let primary		= Action(rawValue: 1 << 0)
	static let secondary	= Action(rawValue: 1 << 1)

	static let combined : Action = [.primary, .secondary]

	static func validate (keyStroke : UInt16) -> Action? {
		switch keyStroke {
		case " ": return Action.primary
		case "r": return Action.secondary
		default: return nil
		}
	}
}

extension UInt16 : ExpressibleByUnicodeScalarLiteral {
	public init(unicodeScalarLiteral value : UnicodeScalar) {
		self = UInt16(value.value)
	}
}
