//
//  PlacesFetchRequest.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

struct PlacesPredictions: Decodable {
    let predictions: [Prediction]
}

struct Prediction: Decodable {
    let description: String
    let id: String
}

struct PlacesFetchRequest: Request  {
    
    typealias Response = String
    
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
