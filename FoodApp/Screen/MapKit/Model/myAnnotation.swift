//
//  myAnnotation.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/2/20.
//

import MapKit

class myAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var marketTintColor: UIColor {
        switch description {
        case "A":
            return .red
        case "B":
            return .blue
        default:
            return .black
        }
    }
}
