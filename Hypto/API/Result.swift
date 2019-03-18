//
//  Result.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failure(Error)
    
    func get() -> T? {
        switch self {
        case .success(let value):
            return value
        default:
            return nil
        }
    }
    
    func error() -> Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}
