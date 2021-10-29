//
//  AppKey.swift
//  Burgan
//
//  Created by Malti Maurya on 22/04/20.
//  Copyright © 2020 1st iMac. All rights reserved.
//

import UIKit

// MARK: - AppKey
struct AppKey: Codable {
    let key: String

    enum CodingKeys: String, CodingKey {
        case key = "KEY"
    }
}

