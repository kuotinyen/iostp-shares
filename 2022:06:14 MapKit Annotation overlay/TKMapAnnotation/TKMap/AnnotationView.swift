//
//  AnnotationView.swift
//  TKMap
//
//  Created by Ting Yen Kuo on 2022/6/14.
//

import MapKit

class TKConvinientStoreMarkerAnnotationView: MKMarkerAnnotationView {
    static let reusableIdentifier = "ConvinientStoreAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "ConvinientStore"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = .red
    }
}

class TKDrinkStoreMarkerAnnotationView: MKMarkerAnnotationView {
    static let reusableIdentifier = "DrinkStoreAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "DrinkStore"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = .orange
    }
}

