//
//  Request.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//
import Foundation

protocol Request {
    associatedtype Response where Response: DataInitial
    var url: String { get  }
    var parameters: [String:String] { get}
    var headers: [String:String] { get }
}

extension Request {
    var headers: [String:String] {
        return [:]
    }
}

extension Request {
    
    private func makeRequest() -> URLRequest {
        var components = URLComponents(string: self.url)!
        var queryItems: [URLQueryItem]
        if let items = components.queryItems {
            queryItems = items
        }else{
            queryItems = []
        }
        for param in parameters {
            queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        components.queryItems = queryItems
        let url = components.url!
        var request = URLRequest(url: url)
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        return request
    }
    
    func execute(completion: @escaping (Result<Response>) -> Void) {
        let request = makeRequest()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            if let data = data, let response = Response.instantiate(from: data) {
//                print(String(data: data, encoding: .utf8)!)
                completion(Result.success(response))
                return
            }
            if let error = error {
                completion(Result.failure(error))
                return
            }
        }
        task.resume()
    }
}
