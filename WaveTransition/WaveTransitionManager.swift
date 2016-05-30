//
//  WaveTransitionManager.swift
//  Light
//
//  Created by Limon on 5/26/16.
//  Copyright © 2016 Light. All rights reserved.
//

import UIKit

protocol WaveTransiting: class {

    var visibleCells: [UIView]  { get }

}

enum WaveTransitionType {
    case Subtle, Nervous, Bounce
}

enum WaveInteractiveWay {
    case EdgePan, FullScreenPan
}


let ScreenWidth = UIScreen.mainScreen().bounds.width


class WaveTransitionManager: NSObject {

    var originalNavigationControllerDelegate: UINavigationControllerDelegate?
    var didPush: Bool = false

    var viewControllersInset: CGFloat = 20.0

    var maxDelay: CGFloat = 1.0

    private var duration: NSTimeInterval = 0.35

    deinit {
        print("ProfileTransitionManager is being deinitialized")
    }
}

extension WaveTransitionManager: UINavigationControllerDelegate {

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension WaveTransitionManager: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return !didPush ? duration * 1.4 : duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        if !didPush {
            pushControllerAnimateWithTransition(transitionContext)
        } else {
            popControllerAnimateWithTransition(transitionContext)
        }
    }

    private func pushControllerAnimateWithTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }

        containerView.addSubview(toViewController.view)

        let delta = viewControllersInset + ScreenWidth

        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        toViewController.view.transform = CGAffineTransformMakeTranslation(delta, 0)

        containerView.backgroundColor = fromViewController.view.backgroundColor

        // Trigger the layout of the new cells
        containerView.layoutIfNeeded()

        toViewController.view.transform = CGAffineTransformMakeTranslation(1, 0)

        UIView.animateWithDuration(duration, delay: 0.0, options: .CurveEaseIn, animations: {

            toViewController.view.transform = CGAffineTransformIdentity

        }, completion: {_ in
            transitionContext.completeTransition(true)

        })

        let fromVisibleViews = visibleCellsForViewController(fromViewController)!
        let toVisibleViews = visibleCellsForViewController(toViewController)!

        let views = [fromVisibleViews, toVisibleViews]

        views.forEach {

            for (index, view) in $0.enumerate() {

                let fromMode = $0 == fromVisibleViews

                let delay = NSTimeInterval(index / $0.count)

                if !fromMode {
                    view.transform = CGAffineTransformMakeTranslation(delta, 0)
                }

                UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {

                    if fromMode {
                        view.transform = CGAffineTransformMakeTranslation(-delta, 0)
                        view.alpha = 0

                    } else {
                        view.transform = CGAffineTransformIdentity
                        view.alpha = 1
                    }


                }, completion: {_ in

                    if fromMode {
                        view.transform = CGAffineTransformIdentity
                    }
                })
            }

        }

    }

    private func popControllerAnimateWithTransition(transitionContext: UIViewControllerContextTransitioning) {

    }

    private func visibleCellsForViewController(viewController: UIViewController) -> [UIView]? {

        return (viewController as? WaveTransiting)?.visibleCells ?? (viewController as? UITableViewController)?.tableView.wave_animatingVisibleViews

//        if let cells = (viewController as? WaveTransiting)?.visibleCells {
//            return cells
//        } else if let visibleViews = (viewController as? UITableViewController)?.tableView.wave_animatingVisibleViews {
//            return visibleViews
//        }
//
//        return nil
    }

}


private extension UITableView {

    var wave_animatingVisibleViews: [UIView] {

        var views = [UIView]()

        if let tableHeaderView = tableHeaderView {
            views.append(tableHeaderView)
        }

        var section: Int = -1

        if let indexPathsForVisibleRows = indexPathsForVisibleRows {

            for (_, indexPath) in indexPathsForVisibleRows.enumerate() {
                if section != indexPath.section {

                    section = indexPath.section

                    if let headerViewForSection = headerViewForSection(section) {
                        views.append(headerViewForSection)
                    }

                    for (_, sectionIndexPath) in indexPathsForVisibleRows.enumerate() {
                        if (sectionIndexPath.section != indexPath.section) {
                            continue
                        }

                        if let cell = cellForRowAtIndexPath(indexPath) {
                            views.append(cell)
                        }
                    }

                    if let footerViewForSection = footerViewForSection(section) {
                        views.append(footerViewForSection)
                    }
                }
            }
        }

        if let tableFooterView = tableFooterView {
            views.append(tableFooterView)
        }

        return views

    }
    

}




