//
//  PlacesFetchRequest.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//
import Foundation

struct PlacesPredictions: Decodable, DataInitial {
    let predictions: [Prediction]
    
    static func instantiate(from data: Data) -> PlacesPredictions? {
        do {
            return try JSONDecoder().decode(PlacesPredictions.self, from: data)
        } catch  {
            return nil
        }
    }
}

struct Prediction: Decodable {
    let description: String
    let id: String
    let placeID: String
    
    private enum CodingKeys: String, CodingKey {
        case description
        case id
        case placeID = "place_id"
    }
}


struct PlacesFetchRequest: Request  {
    
    typealias Response = PlacesPredictions
    
    var url: String {
        return "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    }
    
    var parameters: [String : String] {
        return [
            "input": searchString,
            "key": App.GOOGLE_API_KEY,
            "types": "geocode"
        ]
    }
    let searchString: String
}
