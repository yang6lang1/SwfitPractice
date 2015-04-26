//
//  BezierPathsView.swift
//  DropIt
//
//  Created by Guang Yang on 2015-04-08.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {
    private var bezierPaths = [String: UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String){
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths{
            path.lineWidth = 3
            path.stroke()
        }
    }

}
