//
//  PlaceDetailsFetchRequest.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

struct PlaceDetailsFetchRequest: Request {
    
    typealias Response = String
    
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


struct PlaceDetail: Decodable {
    let latitude: Double
    let longitude: Double
    let formattedAddress: String
    
    //    init(from decoder: Decoder)throws {
    //        let container = try decoder.container(keyedBy: RootContainerKeys.self)
    //        let result = container.nestedContainer(keyedBy: RootContainerKeys.self, forKey: .result)
    //        formattedAddress = try result.decode(String.self, forKey: .form)
    //        let geometry = result.nestedContainer(keyedBy: <#T##CodingKey.Protocol#>, forKey: <#T##PlaceDetail.RootContainerKeys#>)
    //    }
    //
    //    private enum RootContainerKeys: String, CodingKey {
    //        case result
    //        case formattedAddress = "formatted_address"
    //        case geometry
    //        case location
    //        case lat
    //        case lon
    //    }
}
