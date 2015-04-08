//
//  DiagnosedHappinessViewController.swift
//  Psychologist
//
//  Created by Guang Yang on 2015-04-07.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class DiagnosedHappinessViewController : HappinessViewController, UIPopoverPresentationControllerDelegate {
    override var happiness: Int{
        didSet{
            diagnosticHistory += [happiness] //add a new element to the array
        }
    }
    
    //var diagnosticHistory = [Int]() //this won't work because this viewController is instantiated everytime
    private let defaults = NSUserDefaults.standardUserDefaults()
    var diagnosticHistory: [Int] {
        get{
            return defaults.objectForKey(History.DefaultKey) as? [Int] ?? []
        }
        set{
            defaults.setObject(newValue, forKey: History.DefaultKey)
        }
    }
    
    private struct History{
        static let SegueIdentifier = "Show Diagnostic History"
        static let DefaultKey = "DiagnosedHappinessViewController.History"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
