//
//  EnemyPlaneController.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import SpriteKit

class EnemyPlaneController: BaseController {
    
    let SPEED: Double = 50
    let SHOT_DURATION: Double = 1
    
    override func setup(parent: SKNode) {
        addActionFly(parent)
        addActionShot(parent)
        configurePhysics()
    }
    
    override func configurePhysics() {
        
        view.physicsBody = SKPhysicsBody(rectangleOfSize: view.frame.size)
        
        view.physicsBody?.categoryBitMask = PHYSICS_MASK_ENEMY
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = (PHYSICS_MASK_PLAYER_BULLET | PHYSICS_MASK_PLAYER)
    }
    
    func addActionFly(parent: SKNode){
        
        let distanceToBottom = Double(parent.frame.height)
        
        let timeToReachBottom = distanceToBottom / SPEED
        
        self.view.runAction(
            SKAction.sequence(
                [
                    SKAction.moveToY(-view.frame.height, duration: timeToReachBottom),
                    SKAction.removeFromParent()
                ]
            )
        )
    }
    
    func addActionShot(parent: SKNode) {
        self.view.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence(
                    [
                        SKAction.runBlock({ 
                            self.addBullet(parent)
                        }),
                        SKAction.waitForDuration(SHOT_DURATION)
                    ]
                )
            )
        )
    }
    
    private func addBullet(parent: SKNode) {
        let enemyBulletView = View(imageNamed: "enemy_bullet")
        
        enemyBulletView.position = view.position.add(CGPoint(x: 0, y: -view.frame.height/2 - enemyBulletView.frame.height))
        
        let bulletController = EnemyBulletController(view: enemyBulletView)
        
        bulletController.setup(parent)
        
        parent.addChild(enemyBulletView)
        
        
    }
}
