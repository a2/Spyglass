//
//  ColorViewController.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Spyglass
import UIKit

class ColorViewController: UIViewController {
    @IBOutlet var colorView: UIView!
    
    var index: Int?
    var color: UIColor? {
        didSet {
            colorView?.backgroundColor = color
            navigationItem.title = color?.hexValue
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.backgroundColor = color
    }
}
