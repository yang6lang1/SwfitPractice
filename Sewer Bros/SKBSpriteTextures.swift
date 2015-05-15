//
//  SKBSpriteTextures.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-04-22.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SKBSpriteTextures: NSObject {
    let kPlayerStillRightFileName = "Player_Right_Still"
    let kPlayerSkidRightFileName = "Player_RightSkid"
    let kPlayerJumpRightFileName = "Player_RightJump"
    let kPlayerStillLeftFileName = "Player_Left_Still"
    let kPlayerSkidLeftFileName = "Player_LeftSkid"
    let kPlayerJumpLeftFileName = "Player_LeftJump"
    
    let kPlayerRunRight1FileName = "Player_Right1"
    let kPlayerRunRight2FileName = "Player_Right2"
    let kPlayerRunRight3FileName = "Player_Right3"
    let kPlayerRunRight4FileName = "Player_Right4"
    let kPlayerRunLeft1FileName = "Player_Left1"
    let kPlayerRunLeft2FileName = "Player_Left2"
    let kPlayerRunLeft3FileName = "Player_Left3"
    let kPlayerRunLeft4FileName = "Player_Left4"
    
    let kRatzRunRight1FileName = "Ratz_Right1"
    let kRatzRunRight2FileName = "Ratz_Right2"
    let kRatzRunRight3FileName = "Ratz_Right3"
    let kRatzRunRight4FileName = "Ratz_Right4"
    let kRatzRunRight5FileName = "Ratz_Right5"
    
    let kRatzRunLeft1FileName = "Ratz_Left1"
    let kRatzRunLeft2FileName = "Ratz_Left2"
    let kRatzRunLeft3FileName = "Ratz_Left3"
    let kRatzRunLeft4FileName = "Ratz_Left4"
    let kRatzRunLeft5FileName = "Ratz_Left5"
    
    var playerRunRightTextures:[SKTexture]!
    var playerStillFacingRightTextures:[SKTexture]!
    var playerSkiddingRightTextures:[SKTexture]!
    var playerJumpRightTextures:[SKTexture]!
    var playerRunLeftTextures:[SKTexture]!
    var playerStillFacingLeftTextures:[SKTexture]!
    var playerSkiddingLeftTextures:[SKTexture]!
    var playerJumpLeftTextures:[SKTexture]!
    var ratzRunLeftTextures: [SKTexture]!
    var ratzRunRightTextures: [SKTexture]!
    
    func createAnimationTextures(){
        var f1 = SKTexture(imageNamed: kPlayerRunRight1FileName)
        var f2 = SKTexture(imageNamed: kPlayerRunRight2FileName)
        var f3 = SKTexture(imageNamed: kPlayerRunRight3FileName)
        var f4 = SKTexture(imageNamed: kPlayerRunRight4FileName)
        playerRunRightTextures = [f1,f2,f3,f4]
        
        f1 = SKTexture(imageNamed: kPlayerStillRightFileName)
        playerStillFacingRightTextures = [f1]
        
        f1 = SKTexture(imageNamed: kPlayerSkidRightFileName)
        playerSkiddingRightTextures = [f1]
        
        f1 = SKTexture(imageNamed: kPlayerJumpRightFileName)
        playerJumpRightTextures = [f1]
        
        f1 = SKTexture(imageNamed: kPlayerRunLeft1FileName)
        f2 = SKTexture(imageNamed: kPlayerRunLeft2FileName)
        f3 = SKTexture(imageNamed: kPlayerRunLeft3FileName)
        f4 = SKTexture(imageNamed: kPlayerRunLeft4FileName)
        playerRunLeftTextures = [f1,f2,f3,f4]
        
        f1 = SKTexture(imageNamed: kPlayerStillLeftFileName)
        playerStillFacingLeftTextures = [f1]
        
        f1 = SKTexture(imageNamed: kPlayerSkidLeftFileName)
        playerSkiddingLeftTextures = [f1]
        
        f1 = SKTexture(imageNamed: kPlayerJumpLeftFileName)
        playerJumpLeftTextures = [f1]
        
        //Ratz
        f1 = SKTexture(imageNamed: kRatzRunRight1FileName)
        f2 = SKTexture(imageNamed: kRatzRunRight2FileName)
        f3 = SKTexture(imageNamed: kRatzRunRight3FileName)
        f4 = SKTexture(imageNamed: kRatzRunRight4FileName)
        var f5 = SKTexture(imageNamed: kRatzRunRight5FileName)
        ratzRunRightTextures = [f1, f2, f3, f4, f5]
        
        
        f1 = SKTexture(imageNamed: kRatzRunLeft1FileName)
        f2 = SKTexture(imageNamed: kRatzRunLeft2FileName)
        f3 = SKTexture(imageNamed: kRatzRunLeft3FileName)
        f4 = SKTexture(imageNamed: kRatzRunLeft4FileName)
        f5 = SKTexture(imageNamed: kRatzRunLeft5FileName)
        ratzRunLeftTextures = [f1, f2, f3, f4, f5]
    }
}
