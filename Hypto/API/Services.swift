//
//  Services.swift
//  Hypto
//
//  Created by Vigneshkumar G on 14/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import Foundation

struct Services {
    
    static func searchPlaces(input: String) {
        let places = PlacesFetchRequest(searchString: "chennai")
        places.execute { result in
            if let value = result.get() {
                print(value)
            }else {
                print(result.error() ?? " No error")
            }
        }
    }
    
    static func getPlaceDetails(placeId: String) {
        let placeDetails = PlaceDetailsFetchRequest(placeid: placeId)
        placeDetails.execute { result in
            if let value = result.get() {
                print(value)
            }else {
                print(result.error() ?? "no Error")
            }
        }
    }
}
