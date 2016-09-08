//
//  UINavigationController+Spyglass.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/7/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Spyglass
import UIKit

extension UINavigationController: SpyglassTransitionSourceProvider, SpyglassTransitionDestinationProvider {
    public func transitionSource() -> SpyglassTransitionSource? {
        if let sourceProvider = topViewController as? SpyglassTransitionSourceProvider {
            return sourceProvider.transitionSource()
        } else {
            return topViewController as? SpyglassTransitionSource
        }
    }

    public func transitionDestination() -> SpyglassTransitionDestination? {
        if let destinationProvider = topViewController as? SpyglassTransitionDestinationProvider {
            return destinationProvider.transitionDestination()
        } else {
            return topViewController as? SpyglassTransitionDestination
        }
    }
}
