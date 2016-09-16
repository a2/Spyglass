//
//  SpyglassAnimationContext.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/11/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import UIKit

public struct SpyglassAnimationContext {
    public var source: SpyglassTransitionSource
    public var destination: SpyglassTransitionDestination
    public var userInfo: SpyglassUserInfo?
    public weak var snapshotView: UIView?
    public var snapshotSourceRect: SpyglassRelativeRect
    public var snapshotDestinationRect: SpyglassRelativeRect

    public init(source: SpyglassTransitionSource, destination: SpyglassTransitionDestination, userInfo: SpyglassUserInfo?, snapshotView: UIView, snapshotSourceRect: SpyglassRelativeRect, snapshotDestinationRect: SpyglassRelativeRect) {
        self.source = source
        self.destination = destination
        self.userInfo = userInfo
        self.snapshotView = snapshotView
        self.snapshotSourceRect = snapshotSourceRect
        self.snapshotDestinationRect = snapshotDestinationRect
    }
}
