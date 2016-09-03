//
//  SpyglassTransitionSource.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/03/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Foundation

public protocol SpyglassTransitionSourceProvider {
    func transitionSource() -> SpyglassTransitionSource?
}

public protocol SpyglassTransitionSource {
    func userInfo(for transitionType: SpyglassTransitionType, from initialViewController: UIViewController, to finalViewController: UIViewController) -> [String: Any]?
    func snapshotView(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> UIView
    func sourceRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect
}
