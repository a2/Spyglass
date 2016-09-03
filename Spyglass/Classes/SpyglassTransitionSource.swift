//
//  SpyglassTransitionSource.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/03/2016.
//  Copyright (c) 2016 Alexsander Akers. All rights reserved.
//

import Foundation

public protocol SpyglassTransitionSourceProvider {
    func transitionSource() -> SpyglassTransitionSource
}

public protocol SpyglassTransitionSource {
    func userInfo(for transitionType: SpyglassTransitionType) -> [String: Any]?
    func snapshotView(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> UIView
    func sourceRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect
}
