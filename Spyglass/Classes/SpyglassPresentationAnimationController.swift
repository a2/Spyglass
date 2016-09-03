//
//  SpyglassPresentationAnimationController.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/02/2016.
//  Copyright (c) 2016 Alexsander Akers. All rights reserved.
//

import UIKit

public class SpyglassPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var animationDuration = TimeInterval(0.3)

    var transitionType: SpyglassTransitionType {
        return .presentation
    }

    func transitionSource(for viewController: UIViewController) -> SpyglassTransitionSource? {
        if let sourceProvider = viewController as? SpyglassTransitionSourceProvider {
            return sourceProvider.transitionSource()
        } else if let source = viewController as? SpyglassTransitionSource {
            return source
        } else {
            return nil
        }
    }

    func transitionDestination(for viewController: UIViewController) -> SpyglassTransitionDestination? {
        if let destinationProvider = viewController as? SpyglassTransitionDestinationProvider {
            return destinationProvider.transitionDestination()
        } else if let destination = viewController as? SpyglassTransitionDestination {
            return destination
        } else {
            return nil
        }
    }

    // MARK: - Animated Transitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Extract values from `transitionContext`
        let containerView = transitionContext.containerView

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!

        let initialFromFrame = transitionContext.initialFrame(for: fromVC)
        let finalFromFrame = transitionContext.initialFrame(for: fromVC)

        let initialToFrame = transitionContext.initialFrame(for: toVC)
        let finalToFrame = transitionContext.initialFrame(for: toVC)

        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        // Extract transition source / destination
        let transitionSource = self.transitionSource(for: fromVC)
        let transitionDestination = self.transitionDestination(for: toVC)

        // Get snapshotView
        let userInfo: [String: Any]?
        let snapshotView: UIView?
        let snapshotSourceRect: SpyglassRelativeRect?
        let snapshotDestinationRect: SpyglassRelativeRect?

        if let source = transitionSource {
            userInfo = source.userInfo(for: transitionType)
            snapshotView = source.snapshotView(for: transitionType, userInfo: userInfo)
            snapshotSourceRect = source.sourceRect(for: transitionType, userInfo: userInfo)
        } else {
            userInfo = nil
            snapshotView = nil
            snapshotSourceRect = nil
        }

        if let destination = transitionDestination, let userInfo = userInfo {
            snapshotDestinationRect = destination.destinationRect(for: transitionType, userInfo: userInfo)
        } else {
            snapshotDestinationRect = nil
        }

        if let fromView = fromView {
            if initialFromFrame != .zero {
                fromView.frame = initialFromFrame
            }

            containerView.addSubview(fromView)
        }

        if let toView = toView {
            toView.alpha = 0

            if initialToFrame != .zero {
                toView.frame = initialToFrame
            }

            containerView.addSubview(toView)
        }

        if let snapshotView = snapshotView, let sourceRect = snapshotSourceRect, snapshotDestinationRect != nil {
            snapshotView.frame = sourceRect.frame(relativeTo: containerView)
            containerView.addSubview(snapshotView)
        }

        UIView.animate(withDuration: animationDuration, animations: { 
            if let fromView = fromView, finalFromFrame != .zero {
                fromView.frame = finalFromFrame
            }

            if let toView = toView {
                toView.alpha = 1

                if finalToFrame != .zero {
                    toView.frame = finalToFrame
                }
            }

            if let snapshotView = snapshotView, let destinationRect = snapshotDestinationRect {
                snapshotView.frame = destinationRect.frame(relativeTo: containerView)
            }
        }, completion: { _ in
            snapshotView?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
