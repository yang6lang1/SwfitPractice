//
//  DropItBehavior.swift
//  DropIt
//
//  Created by Guang Yang on 2015-04-08.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class DropItBehavior: UIDynamicBehavior {
    let gravity = UIGravityBehavior()
    
    lazy var collider: UICollisionBehavior = {
        let lazilyCreatedCollider = UICollisionBehavior()
        lazilyCreatedCollider.translatesReferenceBoundsIntoBoundary = true
        return lazilyCreatedCollider
    }()

    lazy var dropBehavior: UIDynamicItemBehavior = {
       let lazilyCreateDropBehavior = UIDynamicItemBehavior()
        lazilyCreateDropBehavior.elasticity = 0.75
        lazilyCreateDropBehavior.allowsRotation = true
        return lazilyCreateDropBehavior
    }()
    
    override init(){
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addBarrier(path: UIBezierPath, named name: String){
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func addDrop(drop: UIView){
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(drop: UIView){
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
    
}
