//
//  PlayerBulletController.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import SpriteKit

class PlayerBulletController: BaseController {
    
    let SPEED: CGFloat = 1000
    override func setup(parent: SKNode) {
        addActionFly(parent)
        configurePhysics()
    }
    
    override func configurePhysics() {
        
        view.physicsBody = SKPhysicsBody(rectangleOfSize: view.frame.size)
        
        view.physicsBody?.categoryBitMask = PHYSICS_MASK_PLAYER_BULLET
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = PHYSICS_MASK_ENEMY
    }
    
    private func addActionFly(parent: SKNode) {
        let distanceToRoof = parent.frame.height - view.position.y
        let timeToReachRoof = Double(distanceToRoof / SPEED)
        
        self.view.runAction(
            SKAction.sequence(
                [
                    SKAction.moveToY(parent.frame.height + view.frame.height, duration: timeToReachRoof),
                    SKAction.removeFromParent()
                ]
            )
        )
    }
}
