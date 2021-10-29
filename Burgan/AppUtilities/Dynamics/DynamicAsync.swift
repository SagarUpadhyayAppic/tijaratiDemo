//
//  DynamicAsync.swift
//  DFinder
//
//  Created by Pathak on 22/11/19.
//  Copyright © 2019 Pathak. All rights reserved.
//

import Foundation

class DynamicAsync<T>: Dynamic<T> {
    
    // MARK: - Ovverides
    
    override func fire() {
      self.listener?(self.value)
    }
    
    // MARK: - Initialization
    
    override init(_ v: T) {
        super.init(v)
    }
}

