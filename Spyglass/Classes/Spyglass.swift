//
//  Spyglass.swift
//  Spyglass
//
//  Created by Alexsander Akers on 09/02/2016.
//  Copyright (c) 2016 Alexsander Akers. All rights reserved.
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
