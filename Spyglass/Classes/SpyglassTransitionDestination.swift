//
//  SpyglassTransitionDestination.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/03/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Foundation

public protocol SpyglassTransitionDestinationProvider {
    func transitionDestination() -> SpyglassTransitionDestination?
}

public protocol SpyglassTransitionDestination {
    func destinationRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect
}
