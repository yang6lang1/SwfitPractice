//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Guang Yang on 2015-04-02.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController,FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    private struct Constants{
        static let HappinessGestureScale : CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView) //reset
            }
        default: break
        }
    }
    
    var happiness : Int = 100 {
        // 0 = very sad, 100 = ecstatic
        didSet{
            happiness = min(max(happiness, 0), 100)
            updateUI()
            title = "\(happiness)"
        }
    }
    
    func updateUI(){
        faceView?.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness - 50) / 50
    }
}
