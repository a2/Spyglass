//
//  Spyglass.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/2/2016.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import UIKit

public class Spyglass: NSObject, UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return SpyglassPresentationAnimationController()
        case .pop:
            return SpyglassDismissalAnimationController()
        default:
            return nil
        }
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
}
