//
//  TodaysMenuViewController.swift
//  TodaysReactiveMenu
//
//  Created by Steffen Damtoft Sommer on 25/05/15.
//  Copyright (c) 2015 steffendsommer. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa


class TodaysMenuViewController: UIViewController, MVVMViewResource {

    var viewModel: TodaysMenuViewModel
    private let mainColor       = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
    private let headline        = UILabel()
    private let subHeadline     = UILabel()
    private let mainCourse      = UILabel()
    private let logo            = UIImageView()
    private let sides           = UILabel()
    private let cakeDayBanner   = UIView()
    private let cakeDayText     = UILabel()


    // MARK: - Object Life Cycle
    
    init(viewModel: TodaysMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup RAC bindings.
        setupBindings()
    }

    override func loadView() {
        self.view = UIView(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(self.headline)
        self.view.addSubview(self.subHeadline)
        self.view.addSubview(self.mainCourse)
        self.view.addSubview(self.logo)
        self.view.addSubview(self.sides)
        self.cakeDayBanner.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
        self.view.addSubview(self.cakeDayBanner)
        self.cakeDayBanner.addSubview(self.cakeDayText)
        
        setupConstraints()
    }


    // MARK: - Styling

    func setupConstraints() {
        // Headline.
        self.headline.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.view, withOffset: 30)
        self.headline.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view, withOffset: 50)
        self.headline.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view, withOffset: -50)
        self.headline.autoSetDimension(ALDimension.Height, toSize: 40)
        
        // Subheadline.
        self.subHeadline.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.headline)
        self.subHeadline.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view, withOffset: 50)
        self.subHeadline.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view, withOffset: -50)
        self.subHeadline.autoSetDimension(ALDimension.Height, toSize: 48)

        // Main course.
        self.mainCourse.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.subHeadline, withOffset: 30)
        self.mainCourse.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Top, ofView: self.logo, withOffset: -30)
        self.mainCourse.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view, withOffset: 50)
        self.mainCourse.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view, withOffset: -50)

        // Logo.
        self.logo.autoAlignAxis(ALAxis.Horizontal, toSameAxisOfView: self.view, withOffset: 20)
        self.logo.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        self.logo.autoSetDimensionsToSize(CGSize(width: 75, height: 75))

        // Sides.
        self.sides.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Bottom, ofView: self.logo, withOffset: 30)
        self.sides.autoPinEdge(ALEdge.Bottom, toEdge: ALEdge.Bottom, ofView: self.view, withOffset: -50)
        self.sides.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view, withOffset: 50)
        self.sides.autoPinEdge(ALEdge.Right, toEdge: ALEdge.Right, ofView: self.view, withOffset: -50)

        // Cake day banner.
        self.cakeDayBanner.autoPinEdge(ALEdge.Top, toEdge: ALEdge.Top, ofView: self.view, withOffset: 21)
        self.cakeDayBanner.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: self.view, withOffset:-53)
        self.cakeDayBanner.autoSetDimensionsToSize(CGSize(width: 180, height: 30))
        self.cakeDayText.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
        self.cakeDayText.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Headline.
        self.headline.font = UIFont(name: "GillSans-Italic", size: 30)
        self.headline.textAlignment = NSTextAlignment.Center
        self.headline.textColor = mainColor
        
        // Subheadline.
        self.subHeadline.numberOfLines = 2
        self.subHeadline.textAlignment = NSTextAlignment.Center
        self.subHeadline.font = UIFont(name: "GillSans-Italic", size: 18)
        self.subHeadline.textColor = mainColor

        // Main course.
        self.mainCourse.numberOfLines = 0
        self.mainCourse.textAlignment = NSTextAlignment.Center
        self.mainCourse.font = UIFont(name: "Avenir-Light", size: 30)
        self.mainCourse.adjustsFontSizeToFitWidth = true
        self.mainCourse.textColor = mainColor
        
        // Sides.
        self.sides.numberOfLines = 0
        self.sides.textAlignment = NSTextAlignment.Center
        self.sides.font = UIFont(name: "Avenir-Light", size: 24)
        self.sides.adjustsFontSizeToFitWidth = true
        self.sides.textColor = mainColor
        
        // Cake day banner.
        self.cakeDayBanner.backgroundColor = mainColor
        self.cakeDayText.font = UIFont(name: "Avenir-Black", size: 12)
        self.cakeDayText.textColor = UIColor.whiteColor()
    }

    
    // MARK: - RAC Bindings
    
    func setupBindings() {
        // Setup view helper bindings.
        self.setupViewBindings()
    
        // Setup custom bindings.
        self.headline.rac_hidden <~ self.viewModel.shouldHideMenu.producer.observeOn(UIScheduler())
        self.subHeadline.rac_hidden <~ self.viewModel.shouldHideMenu.producer.observeOn(UIScheduler())
        self.sides.rac_hidden <~ self.viewModel.shouldHideMenu.producer.observeOn(UIScheduler())
    
        self.headline.rac_text <~ self.viewModel.headline.producer.observeOn(UIScheduler())
        self.subHeadline.rac_text <~ self.viewModel.subHeadline.producer.observeOn(UIScheduler())
        self.mainCourse.rac_text <~ self.viewModel.mainCourse.producer.observeOn(UIScheduler())
        self.logo.rac_image <~ self.viewModel.logo.producer.observeOn(UIScheduler())
        self.sides.rac_text <~ self.viewModel.sides.producer.observeOn(UIScheduler())
        self.cakeDayBanner.rac_hidden <~ self.viewModel.isCakeServedToday.producer.observeOn(UIScheduler())
        self.cakeDayText.rac_text <~ self.viewModel.cake.producer.observeOn(UIScheduler())
    }

}
