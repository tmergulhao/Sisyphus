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
import AVFoundation

class ViewController: NSViewController {

	var soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "Ambience", ofType: "wav")!)
	var audioPlayer = AVAudioPlayer()

    @IBOutlet var sceneView : SKView!
    
    override func viewDidLoad() {

		super.viewDidLoad()

		audioPlayer = try! AVAudioPlayer(contentsOf: soundURL)
		audioPlayer.prepareToPlay()

		audioPlayer.play()

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
