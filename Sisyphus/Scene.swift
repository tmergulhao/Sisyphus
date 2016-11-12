//
//  GameScene.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class Scene: SKScene {

	let fontName = "Computer Pixel-7"

	var entities : Array<GKEntity> = [GKEntity]()
	var graphs : Dictionary<String, GKGraph> = [String : GKGraph]()
    
    override func sceneDidLoad() {}

	var previousTime : TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {

        if (previousTime == 0) {
            previousTime = currentTime
        }

		let deltaTime = previousTime - currentTime

        for entity in self.entities {
            entity.update(deltaTime: deltaTime)
        }

		previousTime = currentTime
    }

	var keys : Set<Keys> = []
	var keyGuard : Set<Keys> = []
	var keysMask : UInt16 = 0

	override func keyDown(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = Keys.validate(rawValue: key) else { return }

		keys.insert(validKey)
		keysMask |= validKey.mask
	}

	override func keyUp(with theEvent: NSEvent) {

		let key = theEvent.characters?.utf16.first ?? 0

		guard let validKey = Keys.validate(rawValue: key) else { return }

		keys.remove(validKey)
		keyGuard.remove(validKey)
		keysMask &= ~validKey.mask
	}

}
