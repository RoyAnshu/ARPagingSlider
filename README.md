# ARPagingSlider


A slider for banners, you can customize it according to your use.

# Requirements

1.iOS 9.0+
2.Swift 4.2+
3.Xcode 9.0+

# Installation

CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Alamofire into your Xcode project using CocoaPods, specify it in your Podfile:

pod 'ARPagingSlider'


# Getting Started

import ARPagingSlider

// Subclassing the view to make custom
@IBOutlet weak var pageView: ARPagingSlider!


pageView.showSlider(array: ["img1.jpg","img2.jpeg"], pageControlTintColor: UIColor.white, pageControlSelectedColor: UIColor.red, isAnimated: true, titles: ["Sun rise in east", "Sun set in west"], titleColor: UIColor.white, titleFont: UIFont.init(name: "Cochin-Bold", size: 20), titleShadow: UIColor.red) { (index) in
            self.label.text = String(format: "Index Clicked --> %d", index)
            
}


# License

This project is licensed under the MIT License - see the LICENSE file for details
