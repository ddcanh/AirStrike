//
//  GameScene.swift
//  AirStrike
//
//  Created by Enrik on 9/9/16.
//  Copyright (c) 2016 Enrik. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    var player: SKSpriteNode!
    var bullets = [SKSpriteNode]()
    
    var enemys = [SKSpriteNode]()
    var enemyBullets = [SKSpriteNode]()
    
    var score = 0
    var scoreLabel = SKLabelNode(text: "0")
    
    var previousTime: CFTimeInterval = -1
    
    
    override func didMoveToView(view: SKView) {
        
        addBackGround()
        addPlayer()
        
        setupScoreLabel()
        
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
            
            player.position = currentLocation.subtract(previousLocation).add(player.position)
            
            if player.position.x <= player.frame.width/2 {
                player.position.x = player.frame.width/2
            } else if player.position.x >= self.frame.maxX - player.frame.width/2 {
                player.position.x = self.frame.maxX - player.frame.width/2
            }
            
            if player.position.y <= player.size.height/2 {
                player.position.y  = player.size.height/2
            } else if player.position.y >= self.frame.maxY - player.size.height/2 {
                player.position.y = self.frame.maxY - player.size.height/2
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval){
        
        if previousTime == -1 {
            previousTime = currentTime
        } else {
            let deltaTime = currentTime - previousTime
            
            if deltaTime > 2 {
                addEnemy()
                previousTime = currentTime
            }
        }
        
        for (bulletIndex, bullet) in bullets.enumerate() {
            for (enemyIndex, enemy) in enemys.enumerate() {
                if CGRectIntersectsRect(bullet.frame, enemy.frame) {
                    bullet.removeFromParent()
                    enemy.removeFromParent()
                    bullets.removeAtIndex(bulletIndex)
                    enemys.removeAtIndex(enemyIndex)
                    
                    //update score
                    score += 1
                    scoreLabel.text = String(score)
                }
                
                if enemy.position.y < 0 {
                    enemys.removeAtIndex(enemyIndex)
                }
            }
            if bullet.position.y > self.frame.maxY {
                bullets.removeAtIndex(bulletIndex)
            }
        }
        
        for (enemyBulletIndex, enemyBullet) in enemyBullets.enumerate() {
            
            if CGRectIntersectsRect(enemyBullet.frame, player.frame) {
                
                player.removeFromParent()
                player.position = CGPointZero
                enemyBullet.removeFromParent()
                
                let gameOverLabel = SKLabelNode(text: "Game Over")
                gameOverLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                gameOverLabel.fontColor = UIColor.redColor()
                gameOverLabel.fontSize = 44
                addChild(gameOverLabel)
                self.paused = true
            }
            
            
            if enemyBullet.position.y < 0 && enemyBulletIndex < enemyBullets.count{
                enemyBullets.removeAtIndex(enemyBulletIndex)
            }
            
            
        }
        
        

    }
    
    func addEnemyBullet(enemy: SKSpriteNode) {
        let enemyBullet = SKSpriteNode(imageNamed: "enemy_bullet")
        
        enemyBullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y - enemy.frame.height/2)
        
        let actionFly = SKAction.moveByX(0, y: -20, duration: 0.1)
        
        enemyBullet.runAction(SKAction.repeatActionForever(actionFly))
        
        enemyBullets.append(enemyBullet)
        
        addChild(enemyBullet)
        
    }
    
    func addEnemy() {
        
        // create enemy
        
        let enemy = SKSpriteNode(imageNamed: "plane1.png")
        
        let positionX = CGFloat(arc4random_uniform(UInt32(self.frame.maxX - enemy.frame.width))) + enemy.frame.width/2
        
        enemy.position = CGPoint(x: positionX, y: self.frame.maxY)
        
        // fly action
        
        let actionFly = SKAction.moveByX(0, y: -5, duration: 0.1)
        
        enemy.runAction(SKAction.repeatActionForever(actionFly))
        
        
        // shot action
        let shot = SKAction.runBlock {
            self.addEnemyBullet(enemy)
        }
        
        let periodShot = SKAction.sequence([shot,SKAction.waitForDuration(1)])
        
        enemy.runAction(SKAction.repeatActionForever(periodShot))
        
        enemys.append(enemy)
        
        addChild(enemy)
    }
    
    func addBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + player.frame.height/2 + bullet.frame.height/2 - 2)
        
        let bulletAction = SKAction.moveByX(0, y: 20, duration: 0.1)
        
        bullet.runAction(SKAction.repeatActionForever(bulletAction))
        
      
        
        bullets.append(bullet)
        
        addChild(bullet)
        
    }
    
    func addBackGround(){
        let backGround = SKSpriteNode(imageNamed: "background")
        
        backGround.anchorPoint = CGPointZero
        backGround.position = CGPointZero
        
        addChild(backGround)
        
    }
    
    func addPlayer() {
        player = SKSpriteNode(imageNamed: "plane3.png")
        
        player.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        
        let shot = SKAction.runBlock { 
            self.addBullet()
        }
        
        let periodShot = SKAction.sequence([shot, SKAction.waitForDuration(0.5)])
        
        player.runAction(SKAction.repeatActionForever(periodShot))
        
        addChild(player)
    }
    
    
    
}
