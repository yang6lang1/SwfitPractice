//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Guang Yang on 2015-03-31.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var isTyping = false
    
    var brain = CalculatorBrain()
    //outlet means an instance variable/property that points to the thing in UI
    //optional is automatically given (optional = nil)
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigit(sender: UIButton) {
        //optional type: not set(nil), something
        //type inference
        let digit = sender.currentTitle!
        
        if (isTyping) {
            display.text = display.text! + digit
        }
        else{
            display.text = digit
            isTyping = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if isTyping {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else {
                display.text = "error"
            }
        }
    }
    
    @IBAction func enter() {
        isTyping = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0 // <- error case
        }
    }
    
    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            isTyping = false
        }
    }
}
