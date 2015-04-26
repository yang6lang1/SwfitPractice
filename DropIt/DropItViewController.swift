//
//  DropItViewController.swift
//  DropIt
//
//  Created by Guang Yang on 2015-04-08.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class DropItViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var GameView: BezierPathsView!
    lazy var animator:UIDynamicAnimator = {
        let lazilyCreatedDynamicAnamator = UIDynamicAnimator(referenceView: self.GameView)
        lazilyCreatedDynamicAnamator.delegate = self
        return lazilyCreatedDynamicAnamator
    }()
    
    var dropitBehavior = DropItBehavior()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropitBehavior)
    }
    
    struct PathName {
        static let MiddleBarrier = "Middle Barrier"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let barrierSize = CGSize(width: dropSize.width * 3, height: dropSize.height * 3)
        let barrierOrigin = CGPoint(x: GameView.bounds.midX - barrierSize.width/2, y: GameView.bounds.midY - barrierSize.height/2)
        
        let path = UIBezierPath(ovalInRect: CGRect(origin: barrierOrigin, size: barrierSize))
        dropitBehavior.addBarrier(path, named: PathName.MiddleBarrier)
        GameView.setPath(path, named: PathName.MiddleBarrier)
    }
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        removeCompletedRow()
    }
    
    var dropsPerRow = 10
    
    var dropSize : CGSize{
        let size = GameView.bounds.size.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    @IBAction func drop(sender: UITapGestureRecognizer) {
        drop()
    }
    
    func drop(){
        var frame = CGRect(origin: CGPointZero, size: dropSize)
        frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
        
        let dropView = UIView(frame: frame)
        //dropView.backgroundColor = UIColor.random
        dropitBehavior.addDrop(dropView)
    }
    
    func removeCompletedRow(){
        var dropsToRemove = [UIView]()
        var dropFrame = CGRect(x: 0, y: GameView.frame.maxY, width: dropSize.width, height: dropSize.height)
        
        do{
            dropFrame.origin.y -= dropSize.height
            dropFrame.origin.x = 0
            var dropsFound = [UIView]()
            var rowIsComplete = true
            for _ in 0 ..< dropsPerRow {
                if let hitView = GameView.hitTest(CGPoint(x: dropFrame.midX, y: dropFrame.midY), withEvent: nil){
                    if hitView.superview == GameView {
                        dropsFound.append(hitView)
                    } else{
                        rowIsComplete = true
                    }
                }
                dropFrame.origin.x += dropSize.width
            }
            
            if rowIsComplete {
                dropsToRemove += dropsFound
            }
        }
        while dropsToRemove.count == 0 && dropFrame.origin.y > 0
        
        for drop in dropsToRemove{
            dropitBehavior.removeDrop(drop)
        }
    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat{
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor{
    class var random: UIColor{
        switch arc4random() % 5{
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}