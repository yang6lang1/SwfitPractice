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
    var spriteTextures : SKBSpriteTextures! = nil
    var spawnedEnemyCount = 0
    var enemyIsSpawningFlag = false
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor.blackColor()
        
        let edgeRect = CGRectMake(0, 0, self.frame.width, self.frame.height + 200)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: edgeRect)
        self.physicsBody?.categoryBitMask = Constants.kWallCategory
        self.physicsWorld.contactDelegate = self
        
        //initialize and create our sprite textures
        spriteTextures = SKBSpriteTextures()
        spriteTextures.createAnimationTextures()
        
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
        
        self.createSceneContents()
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
        if !enemyIsSpawningFlag && spawnedEnemyCount < 25 {
            enemyIsSpawningFlag = true
            let castIndex = spawnedEnemyCount
            
            let scheduledDelay = NSTimeInterval(2)
            let leftSideX = CGRectGetMinX(self.frame) + SKBRatz().kEnemySpawnEdgeBufferX
            let rightSideX = CGRectGetMaxX(self.frame) - SKBRatz().kEnemySpawnEdgeBufferX
            let topSideY = CGRectGetMaxY(self.frame) - SKBRatz().kEnemySpawnEdgeBufferY
            
            var startX = CGFloat(0)
            //alternate sides for every other spawn
            if castIndex % 2 == 0 {
                startX = leftSideX
            }
            else {
                startX = rightSideX
            }
            let startY = topSideY
            
            //begin delay & when completed spawn new enemy
            let spacing = SKAction.waitForDuration(scheduledDelay)
            self.runAction(spacing, completion: {
                //Create and spawn new enemy
                self.enemyIsSpawningFlag = false
                self.spawnedEnemyCount++
                
                var newEnemy = SKBRatz()
                newEnemy = newEnemy.initNewRatz(self, startingPoint: CGPointMake(startX, startY), ratzIndex: castIndex)
                newEnemy.spawnInScene(self)
            })
        }
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
        } else if firstBody.categoryBitMask & Constants.kWallCategory > 0 {
            //wall contacts with ratz
            if secondBody.categoryBitMask & Constants.kRatzCategory > 0 {
                let theRatz = secondBody.node as! SKBRatz
                if contact.contactPoint.x < 100 {
                    theRatz.wrapRatz(CGPointMake(self.frame.width - 11, theRatz.position.y))
                }
                else {
                    theRatz.wrapRatz(CGPointMake(11, theRatz.position.y))
                }
            }
        }
        else if firstBody.categoryBitMask & Constants.kRatzCategory > 0 {
            //ratz contacts with ratz
            if secondBody.categoryBitMask & Constants.kRatzCategory > 0 {
                let firstRat = firstBody.node as! SKBRatz
                let secondRat = secondBody.node as! SKBRatz
            
                if firstRat.ratzStatus == SKBRatz.SBRatzStatus.SBRatzRunningLeft {
                    firstRat.turnRight()
                }
                else {
                    firstRat.turnLeft()
                }
                
                if secondRat.ratzStatus == SKBRatz.SBRatzStatus.SBRatzRunningLeft {
                    secondRat.turnRight()
                }
                else {
                    secondRat.turnLeft()
                }
            }
        }
    }

    func createSceneContents() {
        
        // brick base
        let brickImage = SKTexture(imageNamed: "Base_600")
        let brickBase = SKSpriteNode(texture: brickImage, size: CGSize(width: self.frame.size.width, height: brickImage.size().height))
        brickBase.name = "brickBaseNode"
        brickBase.position = CGPointMake(CGRectGetMidX(self.frame), brickBase.size.height / 2)
        brickBase.physicsBody = SKPhysicsBody(rectangleOfSize: brickBase.size)
        brickBase.physicsBody?.categoryBitMask = Constants.kBaseCategory
        brickBase.physicsBody?.dynamic = false
        self.addChild(brickBase)
        
        // ledge
        let ledge = SBLedge()
        var ledgeIndex = 0
        //ledge, bottom left
        var howMany = 0
        if CGRectGetMaxX(self.frame) < 500{
            howMany = 18
        }
        else{
            howMany = 23
        }
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(ledge.kLedgeSideBufferSpacing, brickBase.position.y + 80), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, bottom right
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMaxX(self.frame) - ledge.kLedgeSideBufferSpacing - CGFloat(howMany - 1) * ledge.kLedgeBrickSpacing,  brickBase.position.y + 80), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, middle left
        if CGRectGetMaxX(self.frame) < 500 {
            howMany = 6
        }
        else {
            howMany = 8
        }
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMinX(self.frame) + ledge.kLedgeSideBufferSpacing, brickBase.position.y + 142), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, middle middle
        if CGRectGetMaxX(self.frame) < 500 {
            howMany = 31
        }
        else {
            howMany = 36
        }
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMidX(self.frame) - (CGFloat(howMany) * ledge.kLedgeBrickSpacing) / 2, brickBase.position.y + 142), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, middle right
        if CGRectGetMaxX(self.frame) < 500 {
            howMany = 6
        }
        else {
            howMany = 9
        }
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMaxX(self.frame) - ledge.kLedgeSideBufferSpacing - CGFloat(howMany - 1) * ledge.kLedgeBrickSpacing, brickBase.position.y + 142), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, top left
        if CGRectGetMaxX(self.frame) < 500 {
            howMany = 23
        }
        else {
            howMany = 28
        }
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMinX(self.frame) + ledge.kLedgeSideBufferSpacing, brickBase.position.y + 224), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
        ledgeIndex += howMany
        
        //ledge, top right
        ledge.createNewSetOfLedgeNodes(self, startingPoint: CGPointMake(CGRectGetMaxX(self.frame) - ledge.kLedgeSideBufferSpacing - CGFloat(howMany - 1) * ledge.kLedgeBrickSpacing, brickBase.position.y + 224), withHowManyBlocks: howMany, startingIndex: ledgeIndex)
    }
}