//
//  String+AdditionFeature.swift
//  Talabat
//
//  Created by mostafa elsanadidy on 10/4/20.
//  Copyright © 2020 68lion. All rights reserved.
//

import Foundation

extension String {
mutating func add(text: String?, separatedBy separator: String = "") {
    if let text = text {
        if !isEmpty {
            self += separator
        }
        self += text }
} }
