//
//  TexrViewController.swift
//  Psychologist
//
//  Created by Guang Yang on 2015-04-07.
//  Copyright (c) 2015 Guang Yang. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var textview: UITextView!{
        didSet{
            textview.text = text
        }
    }
    
    var text: String = "" {
        didSet {
            textview?.text = text
        }
    }
    
    override var preferredContentSize: CGSize{
        get{
            if textview != nil && presentingViewController != nil {
                return textview.sizeThatFits(presentingViewController!.view.bounds.size)
            }
            else{
                return super.preferredContentSize
            }
        }
        set{
            super.preferredContentSize = newValue
        }
    }
}
