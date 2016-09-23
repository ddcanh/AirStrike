//
//  PlayerPlaneController.swift
//  AirStrike
//
//  Created by Enrik on 9/23/16.
//  Copyright © 2016 Enrik. All rights reserved.
//

import SpriteKit

class PlayerPlaneController: BaseController {
    
    let SHOT_DURATION = 0.2
    
    override func setup(parent: SKNode) {
        addActionShot(parent, bulletType: SINGLE_BULLET_TYPE)
        configurePhysics()
    }
    
    func changeBullet(parent: SKNode, bulletType: Int){
        view.removeActionForKey("Shot")
        addActionShot(parent, bulletType: bulletType)
    }
    
    override func configurePhysics() {
        
        view.physicsBody = SKPhysicsBody(rectangleOfSize: view.frame.size)
        
        view.physicsBody?.categoryBitMask = PHYSICS_MASK_PLAYER
        view.physicsBody?.collisionBitMask = 0
        view.physicsBody?.contactTestBitMask = (PHYSICS_MASK_ENEMY | PHYSICS_MASK_ENEMY_BULLET)
    }
    
    private func addActionShot(parent: SKNode, bulletType: Int) {
        self.view.runAction(
            SKAction.repeatActionForever(
                SKAction.sequence(
                    [
                       SKAction.runBlock({self.addBullet(parent, bulletType: bulletType)}),
                       SKAction.playSoundFileNamed("laser_shoot.wav", waitForCompletion: false),
                       SKAction.waitForDuration(SHOT_DURATION)
                        
                    ]
                )
            ),withKey: "Shot")
    }
    
    private func addBullet(parent: SKNode, bulletType: Int) {
        
        var bulletView = View()
        
        if bulletType == SINGLE_BULLET_TYPE {
            bulletView = View(imageNamed: "bullet-single")
        } else if bulletType == DOUBLE_BULLET_TYPE {
            bulletView = View(imageNamed: "bullet-double")
        }
        
        bulletView.position = view.position.add(CGPoint(x: 0, y: view.frame.height/2 + bulletView.frame.height/2))
        
        let bulletController = PlayerBulletController(view: bulletView)
        
        bulletController.setup(parent)
        
        parent.addChild(bulletController.view)
        

    }
    
}
