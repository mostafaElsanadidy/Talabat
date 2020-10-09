//
//  JSONStringArrayEncoder.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import Alamofire

struct JSONStringArrayEncoding: ParameterEncoding {
private let myString: String

init(string: String) {
    self.myString = string
}

func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var urlRequest = urlRequest.urlRequest

      let data = myString.data(using: .utf8)!

    if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    urlRequest?.httpBody = data

    return urlRequest!
}}
