//
//  tbDBACell.swift
//  Burgan
//
//  Created by Malti Maurya on 09/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit
class tbDBACell: UITableViewCell {
    
    @IBOutlet weak var locationCv: UICollectionView!
    
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    var collectionViewOffset: CGFloat {
           get {
               return locationCv.contentOffset.x
           }

           set {
               locationCv.contentOffset.x = newValue
           }
       }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
         

           locationCv.delegate = dataSourceDelegate
           locationCv.dataSource = dataSourceDelegate
           locationCv.tag = row
           locationCv.reloadData()
       }
}

