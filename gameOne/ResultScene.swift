//
//  ResultScene.swift
//  gameOne
//
//  Created by caopengxu on 2018/8/3.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import SpriteKit

class ResultScene: SKScene
{
    var won: Bool = false
    
    override func didMove(to view: SKView)
    {
        self.size = screenSize
        self.backgroundColor = UIColor.white
        
        let resultLabel = SKLabelNode(fontNamed: "Chalkduster")
        resultLabel.text = won ? "You Win" : "You lose"
        resultLabel.fontSize = 30
        resultLabel.fontColor = .black
        resultLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        
        self.addChild(resultLabel)
        
        
        let retryLabel = SKLabelNode(fontNamed: "Chalkduster")
        retryLabel.name = "retry"
        retryLabel.text = "Try again"
        retryLabel.fontSize = 20
        retryLabel.fontColor = .blue
        retryLabel.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2 - 30)
        
        self.addChild(retryLabel)
    }
    
    
    // MARK: === 重新开局
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touches.forEach { (touch) in
            
            let touchLocation = touch.location(in: self)
            let node = self.atPoint(touchLocation)
            
            if (node.name == "retry")
            {
                let scene = MyScene()
                let reveal = SKTransition.reveal(with: .up, duration: 1.0)
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
}
