//
//  Mapper.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 06/11/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import Foundation

public class Mapper : Controller {
	public static let instance = { Mapper() }()

	public var active : Bool = false
	public var mapping : Array<Int> = []

	private var previousMapping : Array<Int> = []
	private var currentMappingIndex : Int
	private var preference : Pref360ControlPref?

	public func buttonPressed (atIndex index : CInt) {}

	override init () {
		currentMappingIndex = 0
		
		super.init()

		resetMapping()
	}

	func startMapping () {
		currentMappingIndex = 0
		active = true
		self.setUpPressed(true)
	}
	func stopMapping () {
		super.reset()
		currentMappingIndex = 0
		active = false
		preference?.changeSetting(nil)
		preference?.changeSetting(nil)
	}
	func setUpPressed (_ state : Bool) {

	}
	public func saveCurrentMapping () {
		for i in 0..<15 {
			mapping[i] = previousMapping[i]
		}
	}
	public func restorePreviousMapping () {
		for i in 0..<15 {
			previousMapping[i] = mapping[i]
		}
	}
	func realignButton(toByte index : Int) -> Int {
		switch index {
		case 0: return 12
		case 1: return 13
		case 2: return 14
		case 3: return 15
		case 4: return 8
		case 5: return 9
		case 6: return 6
		case 7: return 7
		case 8: return 4
		case 9: return 5
		case 10: return 10
		case 11: return 0
		case 12: return 1
		case 13: return 2
		case 14: return 3
		default: return -1
		}
	}

	public func buttonPresset (atIndex index : Int) {
		mapping[currentMappingIndex] = realignButton(toByte: index)
		currentMappingIndex += 1
		setButton(atIndex: currentMappingIndex)
		if currentMappingIndex == 15 {
			stopMapping()
		}
	}

	public func resetMapping () {
		for i in 1..<15 {
			mapping[i] = i
		}
		for i in 12..<16 {
			mapping[i-1] = i
		}
	}

	public func reset(withOwner owner : Pref360ControlPref) {
		preference = owner
		reset()
	}

	override public func reset () {
		if preference == nil {
			NSLog("Unable to reset remapping (pref is nil)")
		}
		resetMapping()
		stopMapping()
	}

	func setButton (atIndex index : Int) {
		switch index {
		case 1:
			up = false
			down = true
			break
		case 2:
			down = false
			left = true
			break
		case 3:
			left = false
			right = true
			break
		case 4:
			right = false
			start = true
			break
		case 5:
			start = false
			back = true
			break
		case 6:
			back = false
			lpressed = true
			break
		case 7:
			lpressed = false
			rpressed = true
			break
		case 8:
			rpressed = false
			lb = true
			break
		case 9:
			lb = false
			rb = true
			break
		case 10:
			rb = false
			home = true
			break
		case 11:
			home = false
			a = true
			break
		case 12:
			a = false
			b = true
			break
		case 13:
			b = false
			x = true
			break
		case 14:
			x = false
			y = true
			break
		case 15:
			y = false
			break
		default:
			break
		}
	}
}
