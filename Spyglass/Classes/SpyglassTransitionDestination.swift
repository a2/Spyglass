//
//  SpyglassTransitionDestination.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/03/2016.
//  Copyright (c) 2016 Alexsander Akers. All rights reserved.
//

import Foundation

public protocol SpyglassTransitionDestinationProvider {
    func transitionDestination() -> SpyglassTransitionDestination?
}

public protocol SpyglassTransitionDestination {
    func destinationRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect
}
