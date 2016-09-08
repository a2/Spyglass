//
//  ColorViewController.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/3/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Spyglass
import UIKit

class ColorViewController: UIViewController {
    @IBOutlet var colorView: UIView!

    weak var delegate: ColorViewControllerDelegate?
    var index: Int?
    var color: UIColor? {
        didSet {
            colorView?.backgroundColor = color
            navigationItem.title = color?.hexValue
        }
    }

    // MARK: - Actions

    @IBAction func colorViewTapped(sender: AnyObject?) {
        delegate?.colorViewControllerDidTapColorView(colorViewController: self)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        colorView.backgroundColor = color
    }
}

protocol ColorViewControllerDelegate: class {
    func colorViewControllerDidTapColorView(colorViewController: ColorViewController)
}
