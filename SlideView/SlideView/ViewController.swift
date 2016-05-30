//
//  ViewController.swift
//  SlideView
//
//  Created by Limon on 5/30/16.
//  Copyright © 2016 WaveTransition. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let slidView = SlideView(frame: self.view.bounds)
        view.addSubview(slidView)

    }
}

let ScreenBounds = UIScreen.mainScreen().bounds
let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height

extension UIColor {

    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(Float(r) / 255), green: CGFloat(Float(g) / 255), blue: CGFloat(Float(b) / 255), alpha: a)
    }

    @nonobjc static let eyeBorderColor = UIColor(r: 135, g: 135, b: 135, a: 0.3)
    @nonobjc static let eyeTintColor = UIColor(r: 135, g: 135, b: 135, a: 1.0)
    @nonobjc static let eyeInputTextColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
    @nonobjc static let eyeViewBackgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    @nonobjc static let eyeTabBarTintColor = UIColor(r: 145, g: 150, b: 176, a: 1.0)
    @nonobjc static let eyeChatTextColor = UIColor(r: 135, g: 135, b: 135, a: 1.0)

    @nonobjc static let eyeFeMaleColor = UIColor(r: 197, g: 66, b: 108, a: 1.0)
    @nonobjc static let eyeMaleColor = UIColor(r: 87, g: 164, b: 225, a: 1.0)

    @nonobjc static let eyeTextGrayColor = UIColor(r: 179, g: 179, b: 179, a: 1.0)
    @nonobjc static let eyeTextBlackColor = UIColor(r: 75, g: 76, b: 79, a: 1.0)
    @nonobjc static let eyeNavgationBarTitleColor = UIColor.eyeTextBlackColor

    @nonobjc static let eyeBlueColor = UIColor(r: 99, g: 138, b: 255, a: 1.0)

    @nonobjc static let messageToolBarColor = UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha:1)

    @nonobjc static let yepMessageToolbarSubviewBorderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)

    @nonobjc static let messageToolBarHighlightColor = eyeBlueColor
    
}