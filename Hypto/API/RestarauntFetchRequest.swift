//
//  RestarauntFetchRequest.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import Foundation

struct RestaruntFetchRequest: Request {
    
    typealias Response = RestaruntResponse
    
    var url: String {
        return "https://developers.zomato.com/api/v2.1/search"
    }
    
    var parameters: [String : String] {
        return [
            "lat":"\(latitude)",
            "lon":"\(longitude)",
            "radius":"\(radius)"
        ]
    }
    
    var headers: [String : String] {
        return [
            "user-key":App.ZOMATO_KEY
        ]
    }
    
    let latitude: Double
    let longitude: Double
    let radius: Int
}


struct RestaruntResponse: Decodable {
    let restaurants: [Restarunt]
}

extension RestaruntResponse: DataInitial {
    static func instantiate(from data: Data) -> RestaruntResponse? {
        do {
            let result = try JSONDecoder().decode(RestaruntResponse.self, from: data)
            return result
        } catch  {
            print(error)
            return nil
        }        
    }
}

struct Restarunt: Decodable, Equatable {
    let id: String
    let name: String
    let url: String
    let featured_image: String
    let ratingText: String
    let ratingColor: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let restaurant = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .restaurant)
        self.id = try restaurant.decode(String.self, forKey: .id)
        self.name = try restaurant.decode(String.self, forKey: .name)
        self.url = try restaurant.decode(String.self, forKey: .url)
        self.featured_image = try restaurant.decode(String.self, forKey: .featured_image)
        let userRating = try restaurant.nestedContainer(keyedBy: CodingKeys.self, forKey: .user_rating)
        self.ratingText = try userRating.decode(String.self, forKey: .rating_text)
        self.ratingColor = try userRating.decode(String.self, forKey: .rating_color)
    }
    
    private enum CodingKeys: String, CodingKey {
        case restaurant
        case id
        case name
        case url
        case featured_image
        case user_rating
        case rating_text
        case rating_color
    }
    
    public static func == (lhs: Restarunt, rhs: Restarunt) -> Bool {
        return lhs.id == rhs.id
    }
}


struct HTTPRequest: Request {
    typealias Response = Data
    var url: String
    var parameters: [String : String] = [:]
}
