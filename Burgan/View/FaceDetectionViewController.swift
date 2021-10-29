//
//  FaceDetectionViewController.swift
//  Burgan
//
//  Created by 1st iMac on 14/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
class FaceDetectionViewController : UIViewController
{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    

    var anchorModalToLongForm: Bool {
        return false
}

}
