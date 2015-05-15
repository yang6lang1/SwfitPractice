//
//  SKBRatz.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-05-14.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SKBRatz: SKSpriteNode {
    enum SBRatzStatus {
        case SBRatzRunningLeft
        case SBRatzRunningRight
    }
    
    let kRatzRunningIncrement = 40
    let kEnemySpawnEdgeBufferX = CGFloat(60)
    let kEnemySpawnEdgeBufferY = CGFloat(60)
    
    var ratzStatus: SBRatzStatus!
    var spriteTextures: SKBSpriteTextures!
    
    func initNewRatz(whichScene: SKScene, startingPoint location: CGPoint, ratzIndex index: Int) -> SKBRatz{
        let theScene = whichScene as! SKBGameScene
        spriteTextures = theScene.spriteTextures
        
        let  ratzTexture = SKTexture(imageNamed: spriteTextures.kRatzRunRight1FileName)
        let ratz = SKBRatz(texture: ratzTexture)
        ratz.spriteTextures = spriteTextures
        ratz.name = "ratz\(index)"
        ratz.position = location
        ratz.physicsBody = SKPhysicsBody(rectangleOfSize: ratz.size)
        ratz.physicsBody?.categoryBitMask = Constants.kRatzCategory
        ratz.physicsBody?.contactTestBitMask = Constants.kWallCategory | Constants.kRatzCategory
        ratz.physicsBody?.collisionBitMask = Constants.kLedgeCategory | Constants.kWallCategory | Constants.kBaseCategory | Constants.kRatzCategory
        ratz.physicsBody?.density = CGFloat(1.0)
        ratz.physicsBody?.linearDamping = CGFloat(0.1)
        ratz.physicsBody?.restitution = CGFloat(0.2)
        ratz.physicsBody?.allowsRotation = false

        whichScene.addChild(ratz)
        
        return ratz
    }
    
    func spawnInScene(whichScene: SKScene){
        //set initial direction and start moving
        if self.position.x < CGRectGetMidX(whichScene.frame) {
            self.runRight()
        }
        else {
            self.runLeft()
        }
    }
    func wrapRatz(location: CGPoint){
        let storePB = self.physicsBody
        self.physicsBody = nil
        self.position = location
        self.physicsBody = storePB
    }
    
    func runRight(){
        ratzStatus = .SBRatzRunningRight
        let walkAnimation = SKAction.animateWithTextures(spriteTextures.ratzRunRightTextures, timePerFrame: 0.05)
        let walkForever = SKAction.repeatActionForever(walkAnimation)
        self.runAction(walkForever)
        
        let moveRight = SKAction.moveByX(CGFloat(kRatzRunningIncrement), y: 0, duration: 1)
        let moveForever = SKAction.repeatActionForever(moveRight)
        self.runAction(moveForever)
    }
    
    func runLeft(){
        ratzStatus = .SBRatzRunningLeft
        let walkAnimation = SKAction.animateWithTextures(spriteTextures.ratzRunLeftTextures, timePerFrame: 0.05)
        let walkForever = SKAction.repeatActionForever(walkAnimation)
        self.runAction(walkForever)
        
        let moveLeft = SKAction.moveByX(CGFloat(-kRatzRunningIncrement), y: 0, duration: 1)
        let moveForever = SKAction.repeatActionForever(moveLeft)
        self.runAction(moveForever)
    }
    
    func turnRight(){
        self.ratzStatus = .SBRatzRunningRight
        self.removeAllActions()
        
        let moveRight = SKAction.moveByX(CGFloat(5), y: 0, duration: 0.4)
        self.runAction(moveRight, completion: {
            self.runRight()
        })
    }
    
    func turnLeft(){
        self.ratzStatus = .SBRatzRunningLeft
        self.removeAllActions()
        
        let moveLeft = SKAction.moveByX(CGFloat(-5), y: 0, duration: 0.4)
        self.runAction(moveLeft, completion: {
            self.runLeft()
        })
    }
}