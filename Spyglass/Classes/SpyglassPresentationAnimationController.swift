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

        containerView.layoutIfNeeded()

        // Extract transition source / destination
        let transitionSource = findTransitionSource(for: fromVC)
        let transitionDestination = findTransitionDestination(for: toVC)

        // Get snapshotView
        let userInfo: [String: Any]??
        let snapshotView: UIView?
        let snapshotSourceRect: SpyglassRelativeRect?
        let snapshotDestinationRect: SpyglassRelativeRect?

        if let source = transitionSource, transitionDestination != nil {
            let _userInfo = source.userInfo(for: transitionType, from: fromVC, to: toVC)
            snapshotView = source.snapshotView(for: transitionType, userInfo: _userInfo)
            snapshotSourceRect = source.sourceRect(for: transitionType, userInfo: _userInfo)
            userInfo = _userInfo
        } else {
            snapshotView = nil
            snapshotSourceRect = nil
            userInfo = nil
        }

        if let destination = transitionDestination, let userInfo = userInfo {
            snapshotDestinationRect = destination.destinationRect(for: transitionType, userInfo: userInfo)
        } else {
            snapshotDestinationRect = nil
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
