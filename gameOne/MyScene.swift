//
//  MyScene.swift
//  gameOne
//
//  Created by caopengxu on 2018/8/3.
//  Copyright © 2018年 caopengxu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MyScene: SKScene
{
    var start: CGPoint!
    
    override init()
    {
        super.init()
    }
    
    override init(size: CGSize)
    {
        super.init(size: size)
        
        self.backgroundColor = UIColor.green
        let player = SKSpriteNode(imageNamed: "player")
        start = CGPoint(x: screenWidth / 2, y: player.size.height / 2)
        player.position = start
        self.addChild(player)
        
        addMonster()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: === 添加小怪兽
    func addMonster()
    {
        let monster = SKSpriteNode(imageNamed: "monster")
        
        let minX = monster.size.width / 2
        let maxX = screenWidth - minX
        let rangeX = maxX - minX
        let minY = monster.size.height / 2
        let maxY = screenHeight - minY
        let random = GKRandomSource.sharedRandom()
        let actualX = CGFloat(random.nextInt(upperBound: Int(rangeX)) % Int(rangeX)) + minX
        monster.position = CGPoint(x: actualX, y: maxY)
        self.addChild(monster)
        
        
        let minDuration: Float = 1.0
        let randomFloat = GKRandomSource.sharedRandom().nextUniform()
        let actualDuration = minDuration + randomFloat
        
        let actionMove = SKAction.moveTo(y: minY, duration: TimeInterval(actualDuration))
        monster.run(actionMove) {
            monster.removeFromParent()
            self.addMonster()
        }
        
    }
    
    
    // MARK: === 发射飞镖
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        touches.forEach { (touch) in
            
            let projectile = SKSpriteNode(imageNamed: "projectile.png")
            projectile.position = start
            
            let location = touch.location(in: self)
            let offset = CGPoint(x: location.x - start.x, y: location.y - start.y)
            
            if (offset.y <= 0)
            {
                return
            }
            
            self.addChild(projectile)
            
            let realY = screenHeight + projectile.size.height / 2
            let ratio = offset.x / offset.y
            let realX = (realY - start.y) * ratio + start.x
            let realDest = CGPoint(x: realX, y: realY)
            
            // 时间
            let offRealX = realX - start.x
            let offRealY = realY - start.y
            let length = sqrtf(Float(offRealX * offRealX + offRealY * offRealY))
            let realMoveDuration = length / Float(screenHeight)
            
            let moveAction = SKAction.move(to: realDest, duration: TimeInterval(realMoveDuration))
            
            projectile.run(moveAction, completion: {
                projectile.removeFromParent()
            })
            
        }
        
    }
    
    
    
}
