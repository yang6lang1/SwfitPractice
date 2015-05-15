//
//  SKBPlayer.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-04-22.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SKBPlayer : SKSpriteNode {
    let kPlayerRunningIncrement = 100
    let kPlayerSkiddingIncrement = 20
    let kPlayerJumpingIncrement = 8
    var spriteTextures: SKBSpriteTextures!
    
    enum SBPlayerStatus : Printable {
        case SBPlayerFacingLeft
        case SBPlayerFacingRight
        case SBPlayerRunningLeft
        case SBPlayerRunningRight
        case SBPlayerSkiddingLeft
        case SBPlayerSkiddingRight
        case SBPlayerJumpingLeft
        case SBPlayerJumpingRight
        case SBPlayerJumpUpFacingLeft
        case SBPlayerJumpUpFacingRight
        
        var description : String {
            get {
                switch self {
                case .SBPlayerFacingLeft : return "SBPlayerFacingLeft"
                case .SBPlayerFacingRight: return "SBPlayerFacingRight"
                case .SBPlayerRunningLeft: return "SBPlayerRunningLeft"
                case .SBPlayerRunningRight: return "SBPlayerRunningRight"
                case .SBPlayerSkiddingLeft: return "SBPlayerSkiddingLeft"
                case .SBPlayerSkiddingRight: return "SBPlayerSkiddingRight"
                default: return ""
                }
            }
        }
    }
    var playerStatus: SBPlayerStatus!
    
    func initNewPlayer(whichScene: SKScene, startingPoint location: CGPoint) -> SKBPlayer {
        let theScene = whichScene as! SKBGameScene
        spriteTextures = theScene.spriteTextures
        
        let f1 = SKTexture(imageNamed: spriteTextures.kPlayerStillRightFileName)
        let player = SKBPlayer(texture: f1)

        player.spriteTextures = spriteTextures
        player.playerStatus = SBPlayerStatus.SBPlayerFacingRight
        player.name = "player1"
        player.position = location
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody?.categoryBitMask = Constants.kPlayerCategory
        player.physicsBody?.contactTestBitMask = Constants.kWallCategory
        player.physicsBody?.collisionBitMask = Constants.kBaseCategory | Constants.kLedgeCategory | Constants.kWallCategory
        player.physicsBody?.density = CGFloat(1.0)
        player.physicsBody?.linearDamping = CGFloat(0.1)
        player.physicsBody?.restitution = CGFloat(0.2)
        player.physicsBody?.allowsRotation = false
        whichScene.addChild(player)
        
        return player
    }

    func wrapPlayer(position: CGPoint){
        let storePB = self.physicsBody!
        self.physicsBody = nil
        self.position = position
        self.physicsBody = storePB
    }
    
    func jump(){
        var playerJumpTextures: [SKTexture]!
        var nextPlayerStatus: SKBPlayer.SBPlayerStatus!
        
        //determine direction and next phase
        if let status = self.playerStatus {
            switch (status) {
            case .SBPlayerRunningLeft:
                fallthrough
            case .SBPlayerSkiddingLeft:
                self.playerStatus = .SBPlayerJumpingLeft
                playerJumpTextures = spriteTextures.playerJumpLeftTextures
                nextPlayerStatus = .SBPlayerRunningLeft
            case .SBPlayerRunningRight:
                fallthrough
            case .SBPlayerSkiddingRight:
                self.playerStatus = .SBPlayerJumpingRight
                playerJumpTextures = spriteTextures.playerJumpRightTextures
                nextPlayerStatus = .SBPlayerRunningRight
            case .SBPlayerFacingLeft:
                self.playerStatus = .SBPlayerJumpUpFacingLeft
                playerJumpTextures = spriteTextures.playerJumpLeftTextures
                nextPlayerStatus = .SBPlayerFacingLeft
            case .SBPlayerFacingRight:
                self.playerStatus = .SBPlayerJumpUpFacingRight
                playerJumpTextures = spriteTextures.playerJumpRightTextures
                nextPlayerStatus = .SBPlayerFacingRight
            default: break
            }
        }
        
        //applicable animation
        let jumpAnimation = SKAction.animateWithTextures(playerJumpTextures, timePerFrame: 0.2)
        let jumpAwhile = SKAction.repeatAction(jumpAnimation, count: 4)
        
        self.runAction(jumpAwhile, completion: {
            if let status = nextPlayerStatus {
                switch (status) {
                case .SBPlayerRunningLeft: self.runLeft()
                case .SBPlayerRunningRight: self.runRight()
                case .SBPlayerFacingLeft: self.stillLeft()
                case .SBPlayerFacingRight: self.stillRight()
                default:
                    println("invalid player status after jumping")
                }
            }
        })
        
        //apply jumping impulse
        self.physicsBody?.applyImpulse(CGVectorMake(0, CGFloat(kPlayerJumpingIncrement)))
    }
    
    func stillLeft(){
        self.removeAllActions()
        playerStatus = .SBPlayerFacingLeft
    
        let stillAnimation = SKAction.animateWithTextures(spriteTextures.playerStillFacingLeftTextures, timePerFrame: 1)
        let stillAwhile = SKAction.repeatAction(stillAnimation, count: 1)
        self.runAction(stillAwhile)
    }
    
    func stillRight(){
        self.removeAllActions()
        playerStatus = .SBPlayerFacingRight
        
        let stillAnimation = SKAction.animateWithTextures(spriteTextures.playerStillFacingRightTextures, timePerFrame: 1)
        let stillAwhile = SKAction.repeatAction(stillAnimation, count: 1)
        
        self.runAction(stillAwhile)
    }
    
    func runLeft() {
        self.removeAllActions()
        playerStatus = .SBPlayerRunningLeft
        let walkAnimation = SKAction.animateWithTextures(spriteTextures.playerRunLeftTextures, timePerFrame: 0.1)
        let walkForever = SKAction.repeatActionForever(walkAnimation)
        self.runAction(walkForever)
        
        let moveLeft = SKAction.moveByX(CGFloat(-kPlayerRunningIncrement), y: 0, duration: 1)
        let moveForever = SKAction.repeatActionForever(moveLeft)
        self.runAction(moveForever)
    }
    
    func runRight() {
        self.removeAllActions()
        playerStatus = .SBPlayerRunningRight
        let walkAnimation = SKAction.animateWithTextures(spriteTextures.playerRunRightTextures, timePerFrame: 0.1)
        let walkForever = SKAction.repeatActionForever(walkAnimation)
        self.runAction(walkForever)
        
        let moveRight = SKAction.moveByX(CGFloat(kPlayerRunningIncrement), y: 0, duration: 1)
        let MoveForever = SKAction.repeatActionForever(moveRight)
        self.runAction(MoveForever)
    }
    
    func skidLeft(){
        self.removeAllActions()
        playerStatus = .SBPlayerSkiddingLeft
        
        let playerSkidTextures = spriteTextures.playerSkiddingLeftTextures
        let playerStillTextures = spriteTextures.playerStillFacingLeftTextures
        
        let skidAnimation = SKAction.animateWithTextures(playerSkidTextures, timePerFrame: 0)
        let skidAwhile = SKAction.repeatAction(skidAnimation, count: 1)
        
        let moveLeft = SKAction.moveByX(CGFloat(-kPlayerSkiddingIncrement), y: 0, duration: 0.2)
        let moveAwhile = SKAction.repeatAction(moveLeft, count: 1)
        
        let stillAnimation = SKAction.animateWithTextures(playerStillTextures, timePerFrame: 0.1)
        let stillAwhile = SKAction.repeatAction(stillAnimation, count: 1)
        
        let sequence = SKAction.sequence([skidAwhile,moveAwhile,stillAwhile])
        self.runAction(sequence, completion: { self.playerStatus = .SBPlayerFacingLeft})
    }
    
    func skidRight(){
        self.removeAllActions()
        playerStatus = .SBPlayerSkiddingRight
        
        let playerSkidTextures = spriteTextures.playerSkiddingRightTextures
        let playerStillTextures = spriteTextures.playerStillFacingRightTextures
        
        let skidAnimation = SKAction.animateWithTextures(playerSkidTextures, timePerFrame: 0)
        let skidAWhile = SKAction.repeatAction(skidAnimation, count: 1)
        
        let moveRight = SKAction.moveByX(CGFloat(kPlayerSkiddingIncrement), y: 0, duration: 0.2)
        let moveAWhile = SKAction.repeatAction(moveRight, count: 1)
        
        let stillAnimation = SKAction.animateWithTextures(playerStillTextures, timePerFrame: 0.1)
        let stillAwhile = SKAction.repeatAction(stillAnimation, count: 1)
        
        let sequence = SKAction.sequence([skidAWhile,moveAWhile,stillAwhile])
        self.runAction(sequence, completion: { self.playerStatus = .SBPlayerFacingRight })
    }
}