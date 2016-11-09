//
//  XBController.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 06/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import Foundation

//public struct Stick {
//	let position : NSPoint
//	let pressed : Bool
//	let deadZone : CGFloat
//	let normalized : Bool
//}
//
//public struct Directional {
//	let left : Bool
//	let up : Bool
//	let right : Bool
//	let bottom : Bool
//}
//
//public struct Action {
//	let a : Bool
//	let b : Bool
//	let x : Bool
//	let y : Bool
//}
//
//public struct System {
//	let back : Bool
//	let start : Bool
//	let home : Bool
//	let lb : Bool
//	let rb : Bool
//}

// public struct State {
//	let action : Action
//	let directional : Directional
//	let leftStick : Stick
//	let rightStick : Stick
//	let system : System

//	var leftTrigger : Double
//	var rightTrigger : Double
//
//	// System
//
//	var back : Bool
//	var start : Bool
//	var home : Bool
//	var lb : Bool
//	var rb : Bool
//
//	// Action
//
//	var a : Bool
//	var b : Bool
//	var x : Bool
//	var y : Bool
//
//	// Directional
//
//	var left : Bool
//	var up : Bool
//	var right : Bool
//	var down : Bool
//
//	// Stick
//
//	var lposition : NSPoint
//	var lpressed : Bool
//	var ldeadZone : CGFloat
//	var lnormalized : Bool
//
//	var rposition : NSPoint
//	var rpressed : Bool
//	var rdeadZone : CGFloat
//	var rnormalized : Bool
// }

public class Controller : NSObject {
	public var batteryPercentage : Double
	public let number : Int

	// Trigger

	var leftTrigger : Double
	var rightTrigger : Double

	// System

	var back : Bool
	var start : Bool
	var home : Bool
	var lb : Bool
	var rb : Bool

	// Action

	var a : Bool
	var b : Bool
	var x : Bool
	var y : Bool

	// Directional

	var left : Bool
	var up : Bool
	var right : Bool
	var down : Bool

	// Stick

	var lposition : NSPoint
	var lpressed : Bool
	var ldeadZone : CGFloat
	var lnormalized : Bool

	var rposition : NSPoint
	var rpressed : Bool
	var rdeadZone : CGFloat
	var rnormalized : Bool

	public func setLpositionX (_ position : CInt) {
		var point = lposition
		let value = CGFloat(position)
		point.x = value / 32768.0
		lposition = point
	}
	public func setLpositionY (_ position : CInt) {
		var point = lposition
		let value = CGFloat(position)
		point.y = value / 32768.0
		lposition = point
	}
	public func setRpositionX (_ position : CInt) {
		var point = rposition
		let value = CGFloat(position)
		point.x = value/32768.0
		lposition = point
	}
	public func setRpositionY (_ position : CInt) {
		var point = rposition
		let value = CGFloat(position)
		point.y = value/32768.0
		lposition = point
	}

	override public init () {
		batteryPercentage = 0
		number = 0

		// Trigger

		leftTrigger = 0
		rightTrigger = 0

		// System

		back = false
		start = false
		home = false
		lb = false
		rb = false

		// Action

		a = false
		b = false
		x = false
		y = false

		// Directional

		left = false
		up = false
		right = false
		down = false

		// Stick

		lposition = NSZeroPoint
		lpressed = false
		ldeadZone = 0
		lnormalized = false

		rposition = NSZeroPoint
		rpressed = false
		rdeadZone = 0
		rnormalized = false
	}
	public func reset () {
		leftTrigger = 0
		rightTrigger = 0

		// System

		back = false
		start = false
		home = false
		lb = false
		rb = false

		// Action

		a = false
		b = false
		x = false
		y = false

		// Directional

		left = false
		up = false
		right = false
		down = false

		// Stick

		lposition = NSZeroPoint
		lpressed = false
		ldeadZone = 0
		lnormalized = false

		rposition = NSZeroPoint
		rpressed = false
		rdeadZone = 0
		rnormalized = false
	}
}

public extension Controller {
	public class func drawX360Controller (withNumber number : CGFloat,
	                                      aPressed : Bool,
	                                      bPressed : Bool,
	                                      xPressed : Bool,
	                                      yPressed : Bool,
	                                      leftPressed : Bool,
	                                      upPressed : Bool,
	                                      rightPressed : Bool,
	                                      downPressed : Bool,

	                                      backPressed : Bool,
	                                      startPressed : Bool,
	                                      lbPressed : Bool,
	                                      rbPressed : Bool,
	                                      homePressed : Bool,
	                                      leftStickPressed : Bool,
	                                      rightStickPressed : Bool,
	                                      leftStick : NSPoint,
	                                      rightStick : NSPoint,

	                                      leftStickDeadzone : CGFloat,
	                                      rightStickDeadzone : CGFloat,

	                                      isLeftNormalized : Bool,
	                                      isRightNormalized : Bool) {}
	public class func drawTriggerMetter (withIntensity intensity : CGFloat,
	                                     triggerTitle : NSString) {}
	public class func drawBatteryMonitor (withBars bars : CGFloat,
	                                      andPercentage percentage : Int) {}
	public class func drawDeadZoneViewer (withValue value : CGFloat,
	                                      linked : Bool) {}
}
