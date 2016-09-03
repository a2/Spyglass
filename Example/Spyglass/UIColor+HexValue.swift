//
//  UIColor+HexValue.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/3/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import UIKit

extension UIColor {
    var hexValue: String {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        var result = "#"
        for component in [red, green, blue] {
            let intValue = Int(component * 0xFF)
            let stringValue = String(intValue, radix: 16, uppercase: true)

            for _ in 0 ..< (2 - stringValue.characters.count) {
                result += "0"
            }

            result += stringValue
        }

        return result
    }
}
