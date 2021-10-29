//
//  ParameterEncoding.swift
//  DFinder
//
//  Created by Pathak on 22/11/19.
//  Copyright © 2019 Pathak. All rights reserved.
//

import Alamofire

extension String: ParameterEncoding {
    
    // MARK: - Public Methods
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
