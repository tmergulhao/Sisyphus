//
//  TypedLabel.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import Foundation

//extension String {
//	subscript (r: Range<Int>) -> String {
//		get {
//			if  let start = self.index(self.startIndex, offsetBy: r.lowerBound, limitedBy: self.endIndex),
//				let end = self.index(self.startIndex, offsetBy: r.upperBound, limitedBy: self.endIndex) {
//
//				return self.substring(with: Range<String.Index>(start: start, end: end))
//			}
//
//			return ""
//		}
//	}
//}

class TypedLabel : SKLabelNode {
	var timer : Timer?
	var persistence : String?
	var currentIndex : String.Index?

	let interval : TimeInterval

	override init () {
		interval = 0
		super.init()
	}

    init (typingInterval interval : TimeInterval, fontNamed fontName : String?, andText text: String?) {
		
        self.interval = interval
		super.init(fontNamed: fontName)
        self.text = text
        fontColor = SKColor.white
        fontSize = 30
        horizontalAlignmentMode = .center
        verticalAlignmentMode = .baseline
        

//		timer = Timer(timeInterval: interval, repeats: true, block: {
//			timer in
//
//			Swift.print("Some \(timer)")
//			if true {
//				timer.invalidate()
//			}
//		})

		//timer = Timer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func type () {
		Swift.print(interval)
		Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
	}

	func timerCallback (timer : Timer) {
		// Swift.print("timerCallback \(timer)")

//		Swift.print("Continuous type:")
//		if let text = persistence {
//			self.text = text.substring(to: text.index(text.startIndex, offsetBy: 5))
//			Swift.print("Continuous type: \(self.text)")
//			// timer?.invalidate()
//		} else {
//			persistence = self.text
//			self.text = ""
//		}

		//timer?.invalidate()
//		if let fullText = textPersistence,
//			let index = fullText.index(fullText.startIndex, offsetBy: 3, limitedBy: fullText.endIndex) {
//			text = fullText.substring(to: index)
//		} else if text != nil {
//			textPersistence = text
//			text = ""
//		}
	}
}
