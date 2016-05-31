//
//  ASPhotoBrowser.swift
//  AppSo
//
//  Created by catch on 15/3/24.
//  Copyright (c) 2015年 Limon. All rights reserved.
//

import UIKit

final class SlideView: UIView {

    private var pageView: SlidePageControl!
    private var backgroundImageView: UIImageView!

    private var photoCollectionView: UICollectionView!
    private var screenShotsArray = [UIImage]()
    private var titleTexts = [String]()
    private var labelTexts = [String]()
    private var currentIndex: Int = 0
    private var currentPageIndex: Int = 0 {
        willSet {
            pageView.currentPage = newValue
        }
    }

    private var snapShotImageViews = [Int: UIImageView]()
    private var kCellSize: CGSize = CGSize(width: ScreenWidth, height: ScreenHeight)
    private let kPhotoCellID = "presentExploreApps"
    private lazy var snapShotImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()

        let skipButton = UIButton(type: .Custom)
        skipButton.backgroundColor = UIColor.whiteColor()
        skipButton.setTitle("跳过", forState: .Normal)
        skipButton.frame.size = CGSize(width: 60.0, height: 60.0)
        skipButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        skipButton.titleLabel?.font = UIFont.systemFontOfSize(17.0)
        skipButton.frame.origin = CGPoint(x: ScreenWidth - 20.0 - skipButton.frame.size.width, y: 20.0)
        skipButton.addTarget(self, action: #selector(SlideView.hide), forControlEvents: .TouchUpInside)

        titleTexts.append("1")
        titleTexts.append("2")
        titleTexts.append("3")
        titleTexts.append("4")
        titleTexts.append("5")

        labelTexts.append("你的手机，最值得拥有哪些应用？")
        labelTexts.append("分享 App，最酷的形式是怎样的？")
        labelTexts.append("应用合辑，1+1 > 2 的最好诠释…")
        labelTexts.append("个人中心，只属于你的收藏清单。")
        labelTexts.append("")

        for index in 1...5 {
            if let image = UIImage(named: "slid\(index)") {
                screenShotsArray.append(image)
            }
            if index == 5 {
                if let image = UIImage(named: "slidBackgroundImage") {
                    screenShotsArray.append(image)
                }
            }
        }

        pageView = SlidePageControl(frame: CGRect(x: 0, y: ScreenHeight-40, width: 140, height: 20))
        pageView.center.x = ScreenWidth/2

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        photoCollectionView = UICollectionView(frame: CGRect(origin: CGPointZero, size: CGSize(width: ScreenWidth, height: ScreenHeight)), collectionViewLayout: flowLayout)
        photoCollectionView.pagingEnabled = true
        photoCollectionView.bounces = false
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.showsVerticalScrollIndicator = false
        photoCollectionView.backgroundColor = UIColor.clearColor()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.registerClass(SlidCell.self, forCellWithReuseIdentifier: kPhotoCellID)

        addSubview(photoCollectionView)
        addSubview(pageView)
        addSubview(skipButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func hide() {
        UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseOut, animations: {
            self.alpha = 0.0

            }, completion: { _ in
                self.removeFromSuperview()
        })
    }

}

extension SlideView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenShotsArray.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPhotoCellID, forIndexPath: indexPath) as! SlidCell
        cell.screenShotImageView.image = screenShotsArray[indexPath.row]
        cell.titleLabel.text = labelTexts[indexPath.row]
        cell.titleLabel.sizeToFit()
        cell.titleLabel.center.x = ScreenWidth/2

        cell.introLabel.text = titleTexts[indexPath.row]
        cell.introLabel.sizeToFit()
        cell.introLabel.center.x = ScreenWidth/2

        return cell
    }

    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return kCellSize
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if currentPageIndex == 4 {
            hide()
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let scrollW = scrollView.frame.size.width;
        let currentPage = Int((scrollView.contentOffset.x + scrollW * 0.5) / scrollW)

        if currentPageIndex != currentPage {
            currentPageIndex = currentPage
        }
    }
}

class SlidePageControl: UIView {

    var circleViews = [UIView]()
    var circleIconViews = [SlidCircleView]()

    var currentPage: Int = 0 {
        willSet {

            UIView.animateWithDuration(0.24, delay: 0.0, options: .CurveEaseOut, animations: {

                for (index, circleIconView) in self.circleIconViews.enumerate() {

                    if newValue != index {
                        circleIconView.pointView?.alpha = 1.0
                        circleIconView.selectedPointView?.alpha = 0.0

                    } else {
                        circleIconView.pointView?.alpha = 0.0
                        circleIconView.selectedPointView?.alpha = 1.0
                    }
                }

            }, completion: { _ in })
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        for index in 0...4 {

            var iconImageName = "slid_home"
            switch index {
            case 1:
                iconImageName = "slid_appWall"
            case 2:
                iconImageName = "slid_column"
            case 3:
                iconImageName = "slid_profile"
            case 4:
                iconImageName = "slid_column"
            default:
                break
            }

            let iconViewWH: CGFloat = 20
            let iconViewPaddingLeft: CGFloat = 10
            let iconViewX: CGFloat = index == 0 ? CGFloat(index) * iconViewWH : CGFloat(index) * (iconViewWH + iconViewPaddingLeft)

            var whitePoint = false

            if index == 4 {
                whitePoint = true
            }

            let circleIconView = SlidCircleView(frame: CGRect(x: iconViewX, y: 0, width: iconViewWH, height: iconViewWH), whitePoint: whitePoint, iconImageName: iconImageName)

            circleIconViews.append(circleIconView)

            if index == 0 {
                circleIconView.selectedPointView?.alpha = 1.0
                circleIconView.pointView?.alpha = 0.0
            }

            addSubview(circleIconView)

        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SlidCircleView: UIView {

    var pointView: UIView!
    var selectedPointView: UIView!

    init(frame: CGRect, whitePoint: Bool, iconImageName: String) {
        super.init(frame: frame)

        let circleViewWH: CGFloat = 9

        pointView = UIView(frame: CGRect(x: 0, y: 0, width: circleViewWH, height: circleViewWH))
        pointView.backgroundColor = UIColor.clearColor()
        pointView.layer.masksToBounds = true
        pointView.layer.cornerRadius = circleViewWH/2
        pointView.layer.borderColor = UIColor(r: 179, g: 179, b: 179, a: 1.0).CGColor
        pointView.layer.borderWidth = 1.0
        pointView.center.y = CGRectGetMidY(bounds)
        pointView.center.x = CGRectGetMidX(bounds)

        addSubview(pointView)

        selectedPointView = UIView(frame: pointView.frame)
        selectedPointView.backgroundColor = UIColor.redColor()
        selectedPointView.layer.masksToBounds = true
        selectedPointView.layer.cornerRadius = circleViewWH/2
        selectedPointView.alpha = 0.0

        addSubview(selectedPointView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class SlidCell: UICollectionViewCell {

    var screenShotImageView: UIImageView!
    let titleLabel = UILabel()
    let introLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        screenShotImageView = UIImageView(frame: bounds)
        screenShotImageView.contentMode = .ScaleAspectFill

        titleLabel.text = "地球上最好的 App 都在这里了"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(18)
        titleLabel.sizeToFit()
        titleLabel.center.x = ScreenWidth/2
        titleLabel.frame.origin.y = ScreenHeight - 100

        introLabel.text = "地球上最好的 App 都在这里了"
        introLabel.textColor = UIColor.whiteColor()
        introLabel.font = UIFont.boldSystemFontOfSize(15)
        introLabel.sizeToFit()
        introLabel.center.x = ScreenWidth/2
        introLabel.frame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + 20.0
        
        contentView.addSubview(screenShotImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(introLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


