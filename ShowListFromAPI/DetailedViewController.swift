//
//  DetailedViewController.swift
//  ShowListFromAPI
//
//  Created by Livnoor Brar on 14/09/17.
//  Copyright © 2017 Livnoor Brar. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var holdingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var DescriptionText: UITextView!
    
    var avatarImage: UIImage?
    var avatarName : String = "Detailed View"

    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.image = avatarImage
        self.title = avatarName
        DescriptionText.text = "CocoaPods is a dependency management tool for objective-C projects similar to what Maven's for Java projects, which is written in Ruby and is made of several Ruby Gems. The idea is that once you add the third party libraries to your project you'll no longer need to check if there's any newer versions. CocoaPods will handle that for you. It also makes reversing back to a certain version of the library super easy."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
