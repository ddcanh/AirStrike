//
//  GameScene.swift
//  AirStrike
//
//  Created by Enrik on 9/9/16.
//  Copyright (c) 2016 Enrik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var bullets = [SKSpriteNode]()
    
    var score = 0
    
    var scoreLabel = SKLabelNode(text: "0")
    
    var previousTime: CFTimeInterval = -1
    
    //
    var playerPlaneController: PlayerPlaneController!
    
    override func didMoveToView(view: SKView) {
        
        addBackGround()
        addPlayer()
        addEnemy(4)
        
        addPowerUp(10)
        
        //setupScoreLabel()
        
        configurePhysics()
    
    }
    
    func configurePhysics() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let nodeA = bodyA.node
        let nodeB = bodyB.node
        
        let maskA = bodyA.categoryBitMask
        let maskB = bodyB.categoryBitMask
        
        if ((maskA | maskB) == (PHYSICS_MASK_ENEMY | PHYSICS_MASK_PLAYER)) || ((maskA | maskB) == (PHYSICS_MASK_ENEMY | PHYSICS_MASK_PLAYER_BULLET)) || ((maskA | maskB) == (PHYSICS_MASK_PLAYER | PHYSICS_MASK_ENEMY_BULLET)){
            nodeA?.removeFromParent()
            nodeB?.removeFromParent()
            self.runAction(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
        } else if (maskA | maskB) == (PHYSICS_MASK_PLAYER | PHYSICS_MASK_POWERUP) {
            if maskA == PHYSICS_MASK_POWERUP {
                nodeA?.removeFromParent()
            } else {
                nodeB?.removeFromParent()
            }
            self.runAction(SKAction.playSoundFileNamed("powerup.wav", waitForCompletion: false))
            playerPlaneController.changeBullet(self, bulletType: DOUBLE_BULLET_TYPE)
        }
        
    }
    
    func setupScoreLabel(){
        let textScore = SKLabelNode(text: "Score")
        textScore.fontColor = UIColor.blueColor()
        textScore.fontName = "AvenirNext-Bold"
        textScore.fontSize = 15
        textScore.position = CGPoint(x: 25, y: self.frame.maxY - 20)
        
        scoreLabel.fontColor = UIColor.blueColor()
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 15
        scoreLabel.position = CGPoint(x: 60, y: self.frame.maxY - 20)
        
        addChild(textScore)
        addChild(scoreLabel)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let currentLocation = touch.locationInNode(self)
            let previousLocation = touch.previousLocationInNode(self)
            
            playerPlaneController.moveBy(currentLocation.subtract(previousLocation))
            
            let view = playerPlaneController.view
            
            if view.position.x <= view.frame.width/2 {
                view.position.x = view.frame.width/2
            } else if view.position.x >= self.frame.maxX - view.frame.width/2 {
                view.position.x = self.frame.maxX - view.frame.width/2
            }
            
            if view.position.y <= view.size.height/2 {
                view.position.y  = view.size.height/2
            } else if view.position.y >= self.frame.maxY - view.size.height/2 {
                view.position.y = self.frame.maxY - view.size.height/2
            }
        }
    }
    

    
    override func update(currentTime: CFTimeInterval){
        
        print(self.children.count)
        
    }
    
    func addPowerUp(spawnRate: NSTimeInterval) {
        
        let powerUpSpawn = SKAction.runBlock { 
            
            let powerUpView = View(imageNamed: "power-up.png")
            
            let positionX = CGFloat(arc4random_uniform(UInt32(self.frame.maxX - powerUpView.frame.width))) + powerUpView.frame.width/2
            
            powerUpView.position = CGPoint(x: positionX, y: self.frame.height)
            
            let powerUpController = PowerUpController(view: powerUpView)
            
            powerUpController.setup(self)
            
            self.addChild(powerUpView)
        }
        
        let powerUpAction = SKAction.sequence([SKAction.waitForDuration(spawnRate), powerUpSpawn])
        self.runAction(SKAction.repeatActionForever(powerUpAction))
    }
    
    
    func addEnemy(spawnRate: NSTimeInterval) {
        
        // create enemy
        
        let enemySpawn = SKAction.runBlock{
            // create
            let enemyView = View(imageNamed: "enemy_plane_white_1")
            enemyView.size = CGSize(width: 50, height: 50)
            
            // position
            let positionX = CGFloat(arc4random_uniform(UInt32(self.frame.maxX - enemyView.frame.width))) + enemyView.frame.width/2
            
            enemyView.position = CGPoint(x: positionX, y: self.frame.maxY)
            
            // animate
            var textures = [SKTexture]()
            let nameFormat = "enemy_plane_white_"
            for i in 1...3 {
                let nameImage = nameFormat + String(i)
                let texture = SKTexture(imageNamed: nameImage)
                textures.append(texture)
            }
            
            let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.017)
            enemyView.runAction(SKAction.repeatActionForever(animate))
            
            // addController
            let enemyPlaneController = EnemyPlaneController(view: enemyView)
            enemyPlaneController.setup(self)
            
            //
            self.addChild(enemyView)
        }
        
        let enemyAction = SKAction.sequence([enemySpawn, SKAction.waitForDuration(spawnRate)])
        
        self.runAction(SKAction.repeatActionForever(enemyAction))
        
    }
    
    func addBackGround(){
        let backGround = SKSpriteNode(imageNamed: "background")
        
        backGround.anchorPoint = CGPointZero
        backGround.position = CGPointZero
        
        addChild(backGround)
        
    }
    
    func addPlayer() {
        
        let playerPlaneView = View(imageNamed: "plane3.png")
        
        playerPlaneView.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        self.playerPlaneController = PlayerPlaneController(view: playerPlaneView)
        
        self.playerPlaneController.setup(self)
        
        addChild(playerPlaneController.view)
    }
    
    
    
}
