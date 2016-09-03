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

class RootViewController: UICollectionViewController, SpyglassTransitionSource, SpyglassTransitionDestination, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let colors: [UIColor] = {
        let a = 17
        let b = 3
        return (0 ..< 100).map { i in
            let hue = CGFloat((i * b) % a) / CGFloat(a)
            return UIColor(hue: hue, saturation: 0.8, brightness: 1, alpha: 1)
        }
    }()

    func makeColorViewController(atIndex index: Int) -> ColorViewController {
        let colorViewController = storyboard!.instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        colorViewController.index = index
        colorViewController.color = colors[index]
        return colorViewController
    }

    // MARK: - Collection View

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCellIdentifier, for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: CGFloat(10)])
        pageViewController.dataSource = self
        pageViewController.delegate = self

        let colorViewController = makeColorViewController(atIndex: indexPath.item)
        pageViewController.setViewControllers([colorViewController], direction: .forward, animated: false, completion: nil)
        pageViewController.navigationItem.title = colorViewController.navigationItem.title

        navigationController!.pushViewController(pageViewController, animated: true)
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

    func userInfo(for transitionType: SpyglassTransitionType, from initialViewController: UIViewController, to finalViewController: UIViewController) -> [String: Any]? {
        let pageViewController: UIPageViewController
        switch transitionType {
        case .presentation:
            pageViewController = finalViewController as! UIPageViewController
        case .dismissal:
            pageViewController = initialViewController as! UIPageViewController
        }

        let colorViewController = pageViewController.viewControllers![0] as! ColorViewController
        return [
            SpyglassUserInfoColorKey: colorViewController.color!,
            SpyglassUserInfoIndexKey: colorViewController.index!,
            SpyglassUserInfoRectKey: SpyglassRelativeRect(view: colorViewController.colorView),
        ]
    }

    func snapshotView(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> UIView {
        let view = UIView()
        view.backgroundColor = userInfo?[SpyglassUserInfoColorKey] as? UIColor ?? .black
        return view
    }

    func cellRect(atIndex index: Int) -> SpyglassRelativeRect {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = collectionView!.cellForItem(at: indexPath)!
        return SpyglassRelativeRect(view: cell)
    }

    func sourceRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect {
        switch transitionType {
        case .presentation:
            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            return cellRect(atIndex: index)

        case .dismissal:
            return userInfo![SpyglassUserInfoRectKey] as! SpyglassRelativeRect
        }
    }

    // MARK: - Transition Destination

    func destinationRect(for transitionType: SpyglassTransitionType, userInfo: [String: Any]?) -> SpyglassRelativeRect {
        switch transitionType {
        case .presentation:
            return userInfo![SpyglassUserInfoRectKey] as! SpyglassRelativeRect

        case .dismissal:
            let index = userInfo![SpyglassUserInfoIndexKey] as! Int
            return cellRect(atIndex: index)
        }
    }
}
