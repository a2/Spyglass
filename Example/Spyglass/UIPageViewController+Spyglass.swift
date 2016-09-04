//
//  UIPageViewController+Spyglass.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/4/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Spyglass
import UIKit

extension UIPageViewController: SpyglassTransitionSourceProvider, SpyglassTransitionDestinationProvider {
    public func transitionSource() -> SpyglassTransitionSource? {
        if let sourceProvider = dataSource as? SpyglassTransitionSourceProvider {
            return sourceProvider.transitionSource()
        } else {
            return dataSource as? SpyglassTransitionSource
        }
    }

    public func transitionDestination() -> SpyglassTransitionDestination? {
        if let destinationProvider = dataSource as? SpyglassTransitionDestinationProvider {
            return destinationProvider.transitionDestination()
        } else {
            return dataSource as? SpyglassTransitionDestination
        }
    }
}
