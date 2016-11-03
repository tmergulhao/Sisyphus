//
//  MenuScene.swift
//  Sisyphus
//
//  Created by Andrés Gaitán on 11/3/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var  instruccion : SKLabelNode?
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    
    override func sceneDidLoad() {
        
        
        self.instruccion = SKLabelNode(fontNamed: "Computer-Pixel 7")
        
        
        
        self.lastUpdateTime = 0
        
                }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}
