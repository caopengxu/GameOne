//
//  GameViewController.swift
//  gameOne
//
//  Created by caopengxu on 2018/8/2.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet var skView: SKView!
    var scene: MyScene = {
        let scene = MyScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        skView.presentScene(scene)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let view = self.view as! SKView? {
//
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene")
//            {
//
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
    }

//    override var shouldAutorotate: Bool
//    {
//        return true
//    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    

//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
}
