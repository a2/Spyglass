//
//  RootViewController.swift
//  Spyglass
//
//  Created by Alexsander Akers on 9/2/16.
//  Copyright © 2016 Pandamonia LLC. All rights reserved.
//

import Spyglass
import UIKit

private let DefaultCellIdentifier = "DefaultCell"

class RootViewController: UIViewController, ColorViewControllerDelegate, SpyglassTransitionSource, SpyglassTransitionDestination, UICollectionViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet var collectionView: UICollectionView!

    var colors: [UIColor]!
    var collectionViewDataSource: CollectionViewDataSource!

    func makeColors(stopIncrement: Int = 3, totalStops: Int = 17) -> [UIColor] {
        return (0 ..< 100).map { i in
            let hue = CGFloat((i * stopIncrement) % totalStops) / CGFloat(totalStops)
            return UIColor(hue: hue, saturation: 0.8, brightness: 1, alpha: 1)
        }
    }

    func makeColorViewController(atIndex index: Int) -> ColorViewController {
        let colorViewController = storyboard!.instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        colorViewController.color = colors[index]
        colorViewController.delegate = self
        colorViewController.index = index
        return colorViewController
    }

    func findRootViewController(in viewController: UIViewController) -> RootViewController? {
        if let navigationController = viewController as? UINavigationController, let rootViewController = navigationController.topViewController as? RootViewController {
            return rootViewController
        } else if let rootViewController = viewController as? RootViewController {
            return rootViewController
        } else {
            return nil
        }
    }

    // MARK: - Color View Controller

    func colorViewControllerDidTapColorView(colorViewController: ColorViewController) {
        guard presentedViewController != nil else {
            return
        }

        dismiss(animated: true)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        colors = makeColors()

        collectionViewDataSource = CollectionViewDataSource(colors: colors, cellReuseIdentifier: DefaultCellIdentifier)
        collectionView.dataSource = collectionViewDataSource
    }

    // MARK: - Collection View

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: CGFloat(10)])
        pageViewController.dataSource = self
        pageViewController.delegate = self

        let colorViewController = makeColorViewController(atIndex: indexPath.item)
        pageViewController.setViewControllers([colorViewController], direction: .forward, animated: false, completion: nil)
        pageViewController.navigationItem.title = colorViewController.navigationItem.title

        navigationController!.pushViewController(pageViewController, animated: true)

        // pageViewController.transitioningDelegate = (navigationController?.delegate as! UIViewControllerTransitioningDelegate)
        // present(pageViewController, animated: true)
    }

    // MARK: - Page View Controller

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let colorViewController = viewController as? ColorViewController, let index = colorViewController.index, index > 0 {
            return makeColorViewController(atIndex: index - 1)
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let colorViewController = viewController as? ColorViewController, let index = colorViewController.index, index < colors.count - 1 {
            return makeColorViewController(atIndex: index + 1)
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageViewController.navigationItem.title = pageViewController.viewControllers?.first?.navigationItem.title
    }

    // MARK: - Transition Source

    func userInfo(for transitionType: SpyglassTransitionType, from initialViewController: UIViewController, to finalViewController: UIViewController) -> SpyglassUserInfo? {
        let pageViewController: UIPageViewController
        switch transitionType {
        case .presentation:
            pageViewController = finalViewController as! UIPageViewController
        case .dismissal:
            pageViewController = initialViewController as! UIPageViewController
        }

        let colorViewController = pageViewController.viewControllers![0] as! ColorViewController

        let color = colorViewController.color!
        let index = colorViewController.index!
        let rect = SpyglassRelativeRect(view: colorViewController.colorView)

        if transitionType == .dismissal {
            let rootViewController = findRootViewController(in: finalViewController)!
            let indexPath = IndexPath(item: index, section: 0)
            let frame = rootViewController.collectionView.layoutAttributesForItem(at: indexPath)!.frame
            rootViewController.collectionView.scrollRectToVisible(frame, animated: false)
        }

        return [
            SpyglassUserInfoColorKey: color,
            SpyglassUserInfoIndexKey: index,
            SpyglassUserInfoRectKey: rect,
        ]
    }

    func snapshotView(for transitionType: SpyglassTransitionType, userInfo: SpyglassUserInfo?) -> UIView {
        let view = UIView()
        view.backgroundColor = userInfo?[SpyglassUserInfoColorKey] as? UIColor ?? .black
        return view
    }

    func cellRect(atIndex index: Int) -> SpyglassRelativeRect {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)!
        return SpyglassRelativeRect(view: cell)
    }

    func sourceSnapshotView(for transitionType: SpyglassTransitionType, userInfo: SpyglassUserInfo?) -> UIView {
        return snapshotView(for: transitionType, userInfo: userInfo)
    }

    func sourceRect(for transitionType: SpyglassTransitionType, userInfo: SpyglassUserInfo?) -> SpyglassRelativeRect {
        switch transitionType {
        case .presentation:
            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            return cellRect(atIndex: index)

        case .dismissal:
            return userInfo![SpyglassUserInfoRectKey] as! SpyglassRelativeRect
        }
    }

    func sourceTransitionWillBegin(for transitionType: SpyglassTransitionType, viewController: UIViewController, userInfo: SpyglassUserInfo?) {
        switch transitionType {
        case .presentation:
            // rootViewController === self
            let rootViewController = findRootViewController(in: viewController)!

            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = rootViewController.collectionView?.cellForItem(at: indexPath) {
                cell.isHidden = true
            }

        case .dismissal:
            let pageViewController = viewController as! UIPageViewController
            let colorViewController = pageViewController.viewControllers![0] as! ColorViewController
            colorViewController.colorView.isHidden = true
        }
    }

    func sourceTransitionDidEnd(for transitionType: SpyglassTransitionType, viewController: UIViewController, userInfo: SpyglassUserInfo?, completed: Bool) {
        switch transitionType {
        case .presentation:
            // rootViewController === self
            let rootViewController = findRootViewController(in: viewController)!
            rootViewController.collectionView?.visibleCells.forEach { $0.isHidden = false }

        case .dismissal:
            let pageViewController = viewController as! UIPageViewController
            let colorViewController = pageViewController.viewControllers![0] as! ColorViewController
            colorViewController.colorView.isHidden = false
        }
    }

    // MARK: - Transition Destination

    func destinationSnapshotView(for transitionType: SpyglassTransitionType, userInfo: SpyglassUserInfo?) -> UIView {
        return snapshotView(for: transitionType, userInfo: userInfo)
    }
    
    func destinationRect(for transitionType: SpyglassTransitionType, userInfo: SpyglassUserInfo?) -> SpyglassRelativeRect {
        switch transitionType {
        case .presentation:
            return userInfo![SpyglassUserInfoRectKey] as! SpyglassRelativeRect

        case .dismissal:
            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            return cellRect(atIndex: index)
        }
    }

    func destinationTransitionWillBegin(for transitionType: SpyglassTransitionType, viewController: UIViewController, userInfo: SpyglassUserInfo?) {
        switch transitionType {
        case .presentation:
            let pageViewController = viewController as! UIPageViewController
            let colorViewController = pageViewController.viewControllers![0] as! ColorViewController
            colorViewController.colorView.isHidden = true

        case .dismissal:
            // rootViewController === self
            let rootViewController = findRootViewController(in: viewController)!

            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            let indexPath = IndexPath(item: index, section: 0)
            if let cell = rootViewController.collectionView?.cellForItem(at: indexPath) {
                cell.isHidden = true
            }
        }
    }

    func destinationTransitionDidEnd(for transitionType: SpyglassTransitionType, viewController: UIViewController, userInfo: SpyglassUserInfo?, completed: Bool) {
        switch transitionType {
        case .presentation:
            let pageViewController = viewController as! UIPageViewController
            let colorViewController = pageViewController.viewControllers![0] as! ColorViewController
            colorViewController.colorView.isHidden = false

        case .dismissal:
            // rootViewController === self
            let rootViewController = findRootViewController(in: viewController)!
            rootViewController.collectionView?.visibleCells.forEach { $0.isHidden = false }
        }
    }
}
