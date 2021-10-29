//
//  EndPointType.swift
//  DFinder
//
//  Created by Pathak on 22/11/19.
//  Copyright © 2019 Pathak. All rights reserved.
//


import Alamofire

protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
    
}
