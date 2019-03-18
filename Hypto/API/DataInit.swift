//
//  DataInit.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import Foundation

protocol DataInitial {
    static func instantiate(from data: Data) -> Self?
}

extension String: DataInitial {
    static func instantiate(from data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}

extension Data: DataInitial {
    static func instantiate(from data: Data) -> Data? {
        return data
    }
}
