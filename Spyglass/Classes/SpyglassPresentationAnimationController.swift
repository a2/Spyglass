//
//  SpyglassPresentationAnimationController.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/2/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import UIKit

private let TransitionType = SpyglassTransitionType.presentation

public class SpyglassPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    public var animator: SpyglassAnimator = SpyglassDefaultAnimator(duration: 0.3)
    public var transitionStyle = SpyglassTransitionStyle.navigation
    
    // MARK: - Animated Transitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animator.totalDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Extract values from `transitionContext`
        let containerView = transitionContext.containerView

        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!

        let initialFromFrame = transitionContext.initialFrame(for: fromVC)
        let finalFromFrame = transitionContext.finalFrame(for: fromVC)

        let initialToFrame = transitionContext.initialFrame(for: toVC)
        let finalToFrame = transitionContext.finalFrame(for: toVC)

        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        if let fromView = fromView {
            switch transitionStyle {
            case .navigation:
                if finalFromFrame != .zero {
                    fromView.frame = finalFromFrame
                }

            case .modalPresentation:
                if initialFromFrame != .zero {
                    fromView.frame = initialFromFrame
                }
            }

            containerView.addSubview(fromView)
        }

        if let toView = toView {
            toView.alpha = 0

            switch transitionStyle {
            case .navigation:
                if finalToFrame != .zero {
                    toView.frame = finalToFrame
                }

            case .modalPresentation:
                if initialToFrame != .zero {
                    toView.frame = initialToFrame
                }
            }

            containerView.addSubview(toView)
        }

        containerView.layoutIfNeeded()

        // Extract transition source / destination
        let transitionSource = findTransitionSource(for: fromVC)
        let transitionDestination = findTransitionDestination(for: toVC)

        // Get snapshotView
        let userInfo: SpyglassUserInfo??
        let snapshotView: UIView?
        let snapshotSourceRect: SpyglassRelativeRect?
        let snapshotDestinationRect: SpyglassRelativeRect?

        if let source = transitionSource, transitionDestination != nil {
            let _userInfo = source.userInfo(for: TransitionType, from: fromVC, to: toVC)
            snapshotView = source.snapshotView(for: TransitionType, userInfo: _userInfo)
            snapshotSourceRect = source.sourceRect(for: TransitionType, userInfo: _userInfo)
            userInfo = _userInfo
        } else {
            snapshotView = nil
            snapshotSourceRect = nil
            userInfo = nil
        }

        if let destination = transitionDestination, let userInfo = userInfo {
            snapshotDestinationRect = destination.destinationRect(for: TransitionType, userInfo: userInfo)
        } else {
            snapshotDestinationRect = nil
        }

        if let snapshotView = snapshotView, let sourceRect = snapshotSourceRect, snapshotDestinationRect != nil {
            snapshotView.frame = sourceRect.frame(relativeTo: containerView)
            containerView.addSubview(snapshotView)
        }

        // Notify source / destination about transition start
        let flatUserInfo: SpyglassUserInfo?
        if let userInfo = userInfo {
            flatUserInfo = userInfo
        } else {
            flatUserInfo = nil
        }

        transitionSource?.sourceTransitionWillBegin(for: TransitionType, viewController: fromVC, userInfo: flatUserInfo)
        transitionDestination?.destinationTransitionWillBegin(for: TransitionType, viewController: toVC, userInfo: flatUserInfo)

        let savedTransitionStyle = self.transitionStyle
        animator.perform(animations: {
            if savedTransitionStyle == .modalPresentation, let fromView = fromView, finalFromFrame != .zero {
                fromView.frame = finalFromFrame
            }

            if let toView = toView {
                toView.alpha = 1

                if savedTransitionStyle == .modalPresentation, finalToFrame != .zero {
                    toView.frame = finalToFrame
                }
            }

            if let snapshotView = snapshotView, let destinationRect = snapshotDestinationRect {
                snapshotView.frame = destinationRect.frame(relativeTo: containerView)
            }
        }, completion: { _ in
            snapshotView?.removeFromSuperview()

            let completed = !transitionContext.transitionWasCancelled
            transitionSource?.sourceTransitionDidEnd(for: TransitionType, viewController: fromVC, userInfo: flatUserInfo, completed: completed)
            transitionDestination?.destinationTransitionDidEnd(for: TransitionType, viewController: toVC, userInfo: flatUserInfo, completed: completed)

            transitionContext.completeTransition(completed)
        })
    }
}
