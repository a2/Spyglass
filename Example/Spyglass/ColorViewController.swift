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
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var colorView: UIView!

    weak var delegate: ColorViewControllerDelegate?
    var index: Int?
    var color: UIColor? {
        didSet {
            updateUI()
            navigationItem.title = color?.hexValue
        }
    }

    // MARK: - Configuration

    private func updateUI() {
        guard isViewLoaded else {
            return
        }

        colorView.backgroundColor = color
        nameLabel.text = color?.hexValue
        nameLabel.textColor = color?.contrastingTextColor ?? .black
    }

    // MARK: - Actions

    @IBAction func colorViewTapped(sender: AnyObject?) {
        delegate?.colorViewControllerDidTapColorView(colorViewController: self)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
}

protocol ColorViewControllerDelegate: class {
    func colorViewControllerDidTapColorView(colorViewController: ColorViewController)
}
