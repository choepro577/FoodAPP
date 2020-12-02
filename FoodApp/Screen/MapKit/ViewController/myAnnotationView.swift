//
//  myAnnotationView.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/2/20.
//

import MapKit

class myAnnotationView: MKMarkerAnnotationView {
    override var  annotation: MKAnnotation? {
        willSet {
            guard let _myAnnotetion = newValue as? myAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: -5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = _myAnnotetion.marketTintColor
            glyphText = String(_myAnnotetion.discipline.first!)
        }
    }
}
