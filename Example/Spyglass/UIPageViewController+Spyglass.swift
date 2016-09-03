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
        return dataSource as? SpyglassTransitionSource
    }

    public func transitionDestination() -> SpyglassTransitionDestination? {
        return dataSource as? SpyglassTransitionDestination
    }
}
