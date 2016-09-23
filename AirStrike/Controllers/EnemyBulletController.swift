//
//  EnemyBulletController.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import SpriteKit

class EnemyBulletController: BaseController {
    
    let SPEED: CGFloat = 200
    override func setup(parent: SKNode) {
        addActionFly(parent)
        configurePhysics()
    }
    
    override func configurePhysics(){
        
        view.physicsBody = SKPhysicsBody(rectangleOfSize: view.frame.size)
        
        view.physicsBody?.categoryBitMask = PHYSICS_MASK_ENEMY_BULLET
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = PHYSICS_MASK_PLAYER
    }
    
    
    private func addActionFly(parent: SKNode) {
        let distanceToBottom = view.position.y
        let timeToReachBottom = Double(distanceToBottom / SPEED)
        
        self.view.runAction(
            SKAction.sequence(
                [
                    SKAction.moveToY(-view.frame.height, duration: timeToReachBottom),
                    SKAction.removeFromParent()
                ]
            )
        )
    }
    
}
