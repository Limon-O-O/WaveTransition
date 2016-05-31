//
//  WaveTransitionManager.swift
//  Light
//
//  Created by Limon on 5/26/16.
//  Copyright © 2016 Light. All rights reserved.
//

import UIKit

public protocol WaveTransiting: class {

    var visibleCells: UITableView  { get }

}

enum WaveTransitionType {
    case Subtle, Nervous, Bounce
}

enum WaveInteractiveWay {
    case EdgePan, FullScreenPan
}


let ScreenWidth = UIScreen.mainScreen().bounds.width


public class WaveTransitionManager: NSObject {

    var originalNavigationControllerDelegate: UINavigationControllerDelegate?
    var didPush: Bool = false

    var viewControllersInset: CGFloat = 20.0

    var maxDelay: NSTimeInterval = 0.15

    private var duration: NSTimeInterval = 0.65
    private weak var source: WaveTransiting?
    public weak var destination: WaveTransiting?

    public init<T: UIViewController where T: WaveTransiting>(source: T) {
        self.source = source
        super.init()
    }

    private override init() {}

    deinit {
        print("ProfileTransitionManager is being deinitialized")
    }
}

extension WaveTransitionManager: UINavigationControllerDelegate {

    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension WaveTransitionManager: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return !didPush ? duration + maxDelay : duration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

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

        let destinationViewBlackgroundColor = destination?.visibleCells.backgroundColor
        destination?.visibleCells.backgroundColor = UIColor.clearColor()


        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)

        containerView.backgroundColor = fromViewController.view.backgroundColor
        toViewController.view.backgroundColor = UIColor.clearColor()

        // Trigger the layout of the new cells
        containerView.layoutIfNeeded()

        toViewController.view.transform = CGAffineTransformMakeTranslation(1, 0)

        UIView.animateWithDuration(duration + maxDelay, delay: 0.0, options: .CurveEaseIn, animations: {

            toViewController.view.transform = CGAffineTransformIdentity

        }, completion: {_ in
            self.didPush = true

            self.destination?.visibleCells.backgroundColor = destinationViewBlackgroundColor

            transitionContext.completeTransition(true)
        })

        let fromVisibleViews = visibleCellsForViewController(source!)
        let toVisibleViews = visibleCellsForViewController(destination!)

        let views = [fromVisibleViews, toVisibleViews]

        views.forEach {

            for (index, view) in $0.reverse().enumerate() {

                let fromMode = $0 == fromVisibleViews

                let delay = NSTimeInterval(NSTimeInterval(fromVisibleViews.count - index - 1) / NSTimeInterval(fromVisibleViews.count) * maxDelay)

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
        guard let containerView = transitionContext.containerView(),
            fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }

        containerView.addSubview(toViewController.view)

        let delta = -viewControllersInset - ScreenWidth

        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)

        let sourceViewBlackgroundColor = source?.visibleCells.backgroundColor
        source?.visibleCells.backgroundColor = UIColor.clearColor()

        containerView.backgroundColor = fromViewController.view.backgroundColor
        fromViewController.view.backgroundColor = UIColor.clearColor()
        toViewController.view.backgroundColor = UIColor.clearColor()

        // Trigger the layout of the new cells
        containerView.layoutIfNeeded()

        fromViewController.view.transform = CGAffineTransformMakeTranslation(1, 0)
        toViewController.view.transform = CGAffineTransformIdentity

        UIView.animateWithDuration(duration + maxDelay, delay: 0.0, options: .CurveEaseIn, animations: {

            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)

            }, completion: {_ in
                self.didPush = false
                self.source?.visibleCells.backgroundColor = sourceViewBlackgroundColor
                transitionContext.completeTransition(true)
        })

        let fromVisibleViews = visibleCellsForViewController(destination!)
        let toVisibleViews = visibleCellsForViewController(source!)

        let views = [fromVisibleViews, toVisibleViews]

        views.forEach {

            for (index, view) in $0.reverse().enumerate() {

                let fromMode = $0 == fromVisibleViews

                let delay = NSTimeInterval(NSTimeInterval(fromVisibleViews.count - index - 1) / NSTimeInterval(fromVisibleViews.count) * maxDelay)

                if !fromMode {
                    view.transform = CGAffineTransformMakeTranslation(delta, 0)
                }

                UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {

                    if fromMode {
                        view.transform = CGAffineTransformMakeTranslation(-delta, 0)
                        view.alpha = 0.0

                    } else {
                        view.transform = CGAffineTransformIdentity
                        view.alpha = 1.0
                    }

                    }, completion: {_ in

                        if fromMode {
                            view.transform = CGAffineTransformIdentity
                        }
                })
            }

        }
    }

    private func visibleCellsForViewController(waveTransiting: WaveTransiting) -> [UIView] {
        return waveTransiting.visibleCells.wave_animatingVisibleViews
    }

}


public extension UITableView {

    public var wave_animatingVisibleViews: [UIView] {

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

                        if let cell = cellForRowAtIndexPath(sectionIndexPath) {
                            print(cell.textLabel?.text)
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




