//
//  PlaceDetailsFetchRequest.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//
import Foundation

struct PlaceDetailsFetchRequest: Request {
    
    typealias Response = PlaceDetail
    
    var url: String {
        return "https://maps.googleapis.com/maps/api/place/details/json"
    }
    
    var parameters: [String : String] {
        return [
            "key": App.GOOGLE_API_KEY,
            "placeid":placeid
        ]
    }
    let placeid: String
}


struct PlaceDetail: Decodable, DataInitial {
    let latitude: Double
    let longitude: Double
    let formattedAddress: String
    
    init(from decoder: Decoder)throws {
        let container = try decoder.container(keyedBy: RootContainerKeys.self)
        let result = try container.nestedContainer(keyedBy: RootContainerKeys.self, forKey: .result)
        let geometry = try result.nestedContainer(keyedBy: RootContainerKeys.self, forKey: .geometry)
        let location = try geometry.nestedContainer(keyedBy: RootContainerKeys.self, forKey: .location)
        latitude = try location.decode(Double.self, forKey: .lat)
        longitude = try location.decode(Double.self, forKey: .lng)
        formattedAddress = try result.decode(String.self, forKey: .formattedAddress)
    }
    
    private enum RootContainerKeys: String, CodingKey {
        case result
        case formattedAddress = "formatted_address"
        case geometry
        case location
        case lat
        case lng
    }
    
    static func instantiate(from data: Data) -> PlaceDetail? {
        return try? JSONDecoder().decode(PlaceDetail.self, from: data)
    }
}
