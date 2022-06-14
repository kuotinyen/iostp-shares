//
//  Data.swift
//  TKMap
//
//  Created by Ting Yen Kuo on 2022/6/14.
//

import MapKit

// # MKAnnotationView
// MKAnnotation ~= Data
// MKAnnotationView.populate(MKAnnotation)

// # MapView
// mapView.addAnnotations(...)
// mapView.removeAnnotations(...)

class TKAnnotation: NSObject, MKAnnotation {
    typealias Inputs = (title: String, location: (lat: Double, lon: Double), pinStyle: PinStyle, storeType: StoreType)
    typealias Pin = TKAnnotation
    
    enum PinStyle {
        case highMarker
        case marker
    }
    
    enum StoreType: String {
        case convenientStore // red
        case drink           // orange
    }
    
    var markerTintColor: UIColor {
        if pinStyle == .highMarker { return .white }
            
        switch storeType {
        case .convenientStore: return .red
        case .drink: return .orange
        }
    }
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let pinStyle: PinStyle
    let storeType: StoreType
    
    init(_ inputs: Inputs) {
        self.title = inputs.title
        self.coordinate = .init(latitude: inputs.location.lat, longitude: inputs.location.lon)
        self.pinStyle = inputs.pinStyle
        self.storeType = inputs.storeType
    }
    
    static func convinientStores() -> [TKAnnotation] {
        [
            Pin(("統一超商新運門市", (25.04646, 121.51745), .marker, .convenientStore)),
            Pin(("統一超商億翔店", (25.04615, 121.5173), .marker, .convenientStore)),
            Pin(("統一超商鑫鑫運門市 #", (25.04707, 121.51767), .marker, .convenientStore)),
            Pin(("統一超商鑫鑫運門市 High", (25.04707, 121.51767), .highMarker, .convenientStore)),
        ]
    }
    
    static func drinkStores() -> [TKAnnotation] {
        [
            Pin(("老虎堂", (25.04581, 121.51622), .marker, .drink)),
            Pin(("樺達奶茶", (25.0463846, 121.5178642), .marker, .drink)),
        ]
    }
}
