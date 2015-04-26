//
//  SKBSplashScene.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-04-21.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SKBSplashScene: SKScene {
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor.blackColor()
        var fileName = ""
        if self.frame.size.width == 480 {
            fileName = "SewerSplash_480"
        }
        else{
            fileName = "SewerSplash_568"
        }
        //let splash = SKSpriteNode(imageNamed: fileName)
        let splash = SKSpriteNode(texture: SKTexture(imageNamed: fileName), size: self.frame.size)
        splash.name = "SplashNode"
        splash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(splash)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch in (touches as! Set<UITouch>) {
            if let splashNode = self.childNodeWithName("SplashNode") {
                splashNode.name = nil
                let zoom = SKAction.scaleTo(4.0, duration: 1)
                let fadeaway = SKAction.fadeOutWithDuration(1)
                let grouped = SKAction.group([zoom, fadeaway])
                runAction(grouped, completion: {
                    let nextScene = SKBGameScene(size: self.size)
                    var doors = SKTransition.doorwayWithDuration(0.5)
                    self.view?.presentScene(nextScene, transition: doors)
                })
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
