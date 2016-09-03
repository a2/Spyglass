//
//  SpyglassRelativeRect.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/03/2016.
//  Copyright (c) 2016 Alexsander Akers. All rights reserved.
//

import UIKit

public struct SpyglassRelativeRect {
    // In window coordinates
    fileprivate let rect: CGRect

    public init(rect: CGRect, relativeTo view: UIView) {
        self.rect = view.convert(rect, to: nil)
    }

    public init(view: UIView) {
        self.rect = view.convert(view.bounds, to: nil)
    }

    public func frame(relativeTo view: UIView) -> CGRect {
        return view.convert(rect, from: nil)
    }
}

extension SpyglassRelativeRect: Equatable {
    public static func ==(lhs: SpyglassRelativeRect, rhs: SpyglassRelativeRect) -> Bool {
        return lhs.rect == rhs.rect
    }
}
