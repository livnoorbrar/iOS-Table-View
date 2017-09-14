//
//  DetailedViewController.swift
//  ShowListFromAPI
//
//  Created by Livnoor Brar on 14/09/17.
//  Copyright © 2017 Livnoor Brar. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    var avatarImage: UIImage?
    var avatarName : String = "Detailed View"
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        avatarImageView.image = avatarImage
        self.title = avatarName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
