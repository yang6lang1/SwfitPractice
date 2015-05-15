//
//  SBLedge.swift
//  Sewer Bros
//
//  Created by Guang Yang on 2015-04-26.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import SpriteKit

class SBLedge {
    let kLedgeBrickFileName = "LedgeBrick"
    let kLedgeBrickSpacing = CGFloat(9)
    let kLedgeSideBufferSpacing = CGFloat(4)
    
    func createNewSetOfLedgeNodes(whichScene: SKScene, startingPoint leftSide: CGPoint, withHowManyBlocks blockCount: Int, startingIndex indexStart: Int){
        let ledgeBrickTexture = SKTexture(imageNamed: kLedgeBrickFileName)

        var nodeArray:[SKSpriteNode]! = []
        var location = leftSide
        
        //nodes, equally spaced
        for i in 0...(blockCount-1) {
            let node = SKSpriteNode(texture: ledgeBrickTexture)
            node.name = "ledgeBrick\(i)"
            node.position = location
            node.anchorPoint = CGPointMake(0.5, 0.5)
            node.physicsBody = SKPhysicsBody(rectangleOfSize: node.size)
            node.physicsBody?.categoryBitMask = Constants.kLedgeCategory
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.linearDamping = 1
            node.physicsBody?.angularDamping = 1
            if i == 0 || i == (blockCount - 1){
                node.physicsBody?.dynamic = false
            }
            
            nodeArray.append(node)
            location.x += kLedgeBrickSpacing
        
            whichScene.addChild(node)
        }
        
        //joints between nodes
        for i in 0...(blockCount-2) {
            let nodeA = nodeArray[i]
            let nodeB = nodeArray[i+1]
            let joint = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody, bodyB: nodeB.physicsBody, anchor: CGPointMake(nodeB.position.x, nodeB.position.y))
            joint.frictionTorque = 1
            joint.shouldEnableLimits = true
            joint.lowerAngleLimit = 0
            joint.upperAngleLimit = 0
            whichScene.physicsWorld.addJoint(joint)
        }
    }
}
