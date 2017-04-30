//
//  UIColor+Spyglass.swift
//  Spyglass
//
//  Created by Alexsander Akers on 12/17/16.
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
            let clampedValue = min(max(component, 0), 1)
            let intValue = Int(clampedValue * 0xFF)
            let stringValue = String(intValue, radix: 16, uppercase: true)

            for _ in 0 ..< (2 - stringValue.characters.count) {
                result += "0"
            }

            result += stringValue
        }
        
        return result
    }

    var contrastingTextColor: UIColor {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        if red < 0 {
            red = 0
        } else if red > 1 {
            red = 1
        }

        if green < 0 {
            green = 0
        } else if green > 1 {
            green = 1
        }

        if blue < 0 {
            blue = 0
        } else if blue > 1 {
            blue = 1
        }

        let luminance = sqrt(0.299 * red * red + 0.587 * green * green + 0.114 * blue * blue)
        if luminance > 0.5 {
            return .black
        } else {
            return .white
        }
    }
}
