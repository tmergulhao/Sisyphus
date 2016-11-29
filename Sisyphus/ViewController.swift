//
//  ViewController.swift
//  Sisyphus
//
//  Created by Tiago Mergulhão on 28/10/16.
//  Copyright © 2016 Tiago Mergulhão. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var sceneView : SKView!
    
    override func viewDidLoad() {

		super.viewDidLoad()

		view.layer?.backgroundColor = .white

		guard let scene = GKScene(fileNamed: "Title") else { fatalError("No scene file on bundle") }

		guard let sceneNode = scene.rootNode as? TitleScene else { fatalError("Scene node does not match given class") }
			
		sceneNode.entities = scene.entities
		sceneNode.graphs = scene.graphs
		
		sceneNode.scaleMode = .aspectFill

		guard let view = self.sceneView else { fatalError("Scene View does not referenced on Storyboard") }
		
		view.presentScene(sceneNode)

		view.ignoresSiblingOrder = true

		view.showsFPS = true
		view.showsNodeCount = true
    }
}
