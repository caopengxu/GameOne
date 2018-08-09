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
import AVFoundation

class MyScene: SKScene
{
    var start: CGPoint!
    var monsters: [SKSpriteNode] = {
        let array = [SKSpriteNode]()
        return array
    }()
    var projectiles: [SKSpriteNode] = {
        let array = [SKSpriteNode]()
        return array
    }()
    var monstersDestroyed = 0
    
    var bgmPlayer: AVAudioPlayer = {
        let bgmPath = Bundle.main.path(forResource: "background-music-aac", ofType: "caf")
        let player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: bgmPath!))
        return player
    }()
    var projectileSoundEffectAction: SKAction = {
        let action = SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false)
        return action
    }()
    
    
    // 初始化
    override func didMove(to view: SKView)
    {
        self.size = screenSize
        self.backgroundColor = UIColor.green
        
//        bgmPlayer.play()
        addPlayer()
        cycle()
    }
    
    
    // MARK: === 添加忍者
    func addPlayer()
    {
        let player = SKSpriteNode(imageNamed: "player")
        start = CGPoint(x: screenWidth / 2, y: player.size.height / 2)
        player.position = start
        self.addChild(player)
    }
    
    
    // MARK: === 循环
    func cycle()
    {
        let actionAddMonster = SKAction.run {
            self.addMonster()
        }
        let actionWaitNextMonster = SKAction.wait(forDuration: 1.0)
        self.run(SKAction.repeatForever(SKAction.sequence([actionAddMonster, actionWaitNextMonster])))
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
            self.monsters.removeFirst()
            self.changeToResultSceneWithWon(false)
        }
        
        monsters.append(monster)
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
            projectile.run(SKAction.group([moveAction, projectileSoundEffectAction]), completion: {
                projectile.removeFromParent()
                self.projectiles.removeFirst()
            })
            
            projectiles.append(projectile)
        }
    }
    
    
    // MARK: === 检测碰撞
    override func update(_ currentTime: TimeInterval)
    {
        var projectilesToDelete = [SKSpriteNode]()
        var monstersToDelete = [SKSpriteNode]()
        
        projectiles.forEach { (projectile) in
            
            monsters.forEach({ (monster) in
                
                if (projectile.frame.intersects(monster.frame))
                {
                    monstersToDelete.append(monster)
                    projectilesToDelete.append(projectile)
                }
            })
        }
        
        monstersToDelete.forEach { (monster) in
            
            let temp = self.monsters.filter {$0 != monster}
            self.monsters = temp
            monster.removeFromParent()
            
            self.monstersDestroyed += 1
            if (self.monstersDestroyed >= 30)
            {
                changeToResultSceneWithWon(true)
            }
        }
        projectilesToDelete.forEach { (projectile) in
            
            let temp = self.projectiles.filter {$0 != projectile}
            self.projectiles = temp
            projectile.removeFromParent()
        }
    }
    
    
    // MARK: === 结束
    func changeToResultSceneWithWon(_ won: Bool)
    {
        bgmPlayer.stop()
        
        let scene = ResultScene()
        scene.won = won
        let reveal = SKTransition.reveal(with: .down, duration: 1.0)
        self.view?.presentScene(scene, transition: reveal)
    }
}
