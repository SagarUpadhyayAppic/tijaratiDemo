//
//  RootViewController.swift
//  Burgan
//
//  Created by Malti Maurya on 28/03/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        menuPreferredStatusBarStyle = .lightContent
        contentViewShadowColor = .black
        contentViewShadowOffset = CGSize(width: 0, height: 0)
        contentViewShadowOpacity = 0.6
        contentViewShadowRadius = 12
        
        contentViewShadowEnabled = true
        contentViewController = storyboard?.instantiateViewController(withIdentifier: "navigation")
        leftMenuViewController = storyboard?.instantiateViewController(withIdentifier: "NavigationDrawerViewController")
        rightMenuViewController = storyboard?.instantiateViewController(withIdentifier: "NavigationDrawerViewController")
        view.backgroundColor = .black
        panGestureEnabled = false
        delegate = self
    }
    
  
     
}
