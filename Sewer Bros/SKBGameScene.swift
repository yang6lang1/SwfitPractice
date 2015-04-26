//
//  SKBGameScene.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-04-21.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SKBGameScene :SKScene, SKPhysicsContactDelegate {
    var playerSprite : SKBPlayer! = nil
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor.blackColor()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = Constants.kWallCategory
        self.physicsWorld.contactDelegate = self
        
        // backdrop
        var fileName = ""
        if self.frame.size.width == 480 {
            fileName = "Backdrop_480"
        }
        else {
            fileName = "Backdrop_568"
        }
        let backdrop = SKSpriteNode(texture: SKTexture(imageNamed: fileName), size: self.frame.size)
        //let backdrop = SKSpriteNode(imageNamed: fileName)
        backdrop.name = "BackdropNode"
        backdrop.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(backdrop)
        
        // brick base
        let brickImage = SKTexture(imageNamed: "Base_600")
        let brickBase = SKSpriteNode(texture: brickImage, size: CGSize(width: self.frame.size.width, height: brickImage.size().height))
        brickBase.name = "brickBaseNode"
        brickBase.position = CGPointMake(CGRectGetMidX(self.frame), brickBase.size.height / 2)
        brickBase.physicsBody = SKPhysicsBody(rectangleOfSize: brickBase.size)
        brickBase.physicsBody?.categoryBitMask = Constants.kBaseCategory
        brickBase.physicsBody?.dynamic = false
        self.addChild(brickBase)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if playerSprite == nil {
                playerSprite = SKBPlayer().initNewPlayer(self, startingPoint: location)
            }
            else if location.y > (self.frame.size.height / 2) {
                let status = playerSprite.playerStatus
                if (status != .SBPlayerJumpingLeft) && (status != .SBPlayerJumpingRight) &&
                (status != .SBPlayerJumpUpFacingLeft) && (status != .SBPlayerJumpUpFacingRight) {
                    playerSprite.jump()
                }
            }
            else if location.x < (self.frame.size.width / 2) {
                if playerSprite.playerStatus == .SBPlayerRunningRight {
                    playerSprite.skidRight()
                }
                else if playerSprite.playerStatus == .SBPlayerFacingLeft ||
                playerSprite.playerStatus == .SBPlayerFacingRight {
                    playerSprite.runLeft()
                }
            }
            else {
                if playerSprite.playerStatus == .SBPlayerRunningLeft {
                    playerSprite.skidLeft()
                }
                else if playerSprite.playerStatus == .SBPlayerFacingLeft ||
                    playerSprite.playerStatus == .SBPlayerFacingRight {
                    playerSprite.runRight()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody, secondBody : SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let firstBodyName = firstBody.node?.name
        
        if firstBody.categoryBitMask & Constants.kPlayerCategory > 0 {
            //player contact with wall
            if secondBody.categoryBitMask & Constants.kWallCategory > 0 {
                if firstBodyName == "player1" {
                    //contact with left wall
                    if contact.contactPoint.x < 100 {
                        playerSprite.wrapPlayer(CGPointMake(self.frame.width - 10, playerSprite.position.y))
                    }
                    else {
                        playerSprite.wrapPlayer(CGPointMake(10, playerSprite.position.y))
                    }
                }
            }
        }
    }

}