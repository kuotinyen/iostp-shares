//
//  ViewController.swift
//  TKMap
//
//  Created by Ting Yen Kuo on 2022/6/14.
//

import UIKit
import MapKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var usingCluster = false
    private var annotationImage: UIImage?
    
    private var displayedAnnotations: [MKAnnotation] = [] {
        willSet { mapView.removeAnnotations(displayedAnnotations) }
        didSet { mapView.addAnnotations(displayedAnnotations) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // [Spike 2-1] glyphImage by imageUrl is OK, [Spike 2-2] auto-filter
        SDWebImageManager.shared.loadImage(with: URL(string: coffeeImageUrl), progress: nil) { [weak self] image, _, error, _, _, _ in
            guard let self = self else { return }
            self.annotationImage = image
            self.displayedAnnotations = self.displayedAnnotations
        }
        // End
        
        setupMapView()
        displayedAnnotations = TKAnnotation.drinkStores() + TKAnnotation.convinientStores()
        mapView.showAnnotations(displayedAnnotations, animated: true)
    }
    
    private func setupMapView() {
        // [Spike 3] Let's play
        mapView.selectableMapFeatures = [
            .pointsOfInterest, // POI
            .physicalFeatures, // lake, ocean 等物理地形
            .territories // 地名
        ]

        mapView.pointOfInterestFilter = .init(including: [.airport, .bank, .gasStation, .hospital, .park, .school, .university, .zoo])
        mapView.delegate = self
        
        if usingCluster {
            mapView.register(TKConvinientStoreMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: TKConvinientStoreMarkerAnnotationView.reusableIdentifier)
            mapView.register(TKDrinkStoreMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: TKDrinkStoreMarkerAnnotationView.reusableIdentifier)
        } else {
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Marker")
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("#### didSelectview: \(view)")
        print("#### didSelectview \(view.image)")
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        print("#### didSelectannotation: \(annotation)")
        print("#### didSelectannotation: \(annotation.coordinate), \(annotation.title), \(annotation.subtitle)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if usingCluster {
            var annoationView: MKAnnotationView?
            if let annotation = annotation as? TKAnnotation {
                switch annotation.storeType {
                case .convenientStore:
                    annoationView = TKConvinientStoreMarkerAnnotationView(annotation: annotation, reuseIdentifier: TKConvinientStoreMarkerAnnotationView.reusableIdentifier)
                case .drink:
                    annoationView = TKDrinkStoreMarkerAnnotationView(annotation: annotation, reuseIdentifier: TKDrinkStoreMarkerAnnotationView.reusableIdentifier)
                }
            } else {
                annoationView = nil
            }
            
            if let annoationView = annoationView as? MKMarkerAnnotationView {
                annoationView.glyphImage = annotationImage
            }
            
            return annoationView
        } else {
            guard let annotation = annotation as? TKAnnotation,
                    let marker = mapView.dequeueReusableAnnotationView(withIdentifier: "Marker", for: annotation) as? MKMarkerAnnotationView else { return nil }
            marker.markerTintColor = annotation.markerTintColor
            marker.glyphImage = annotationImage
            
            // [Spike 1] Fix overlap issue code block
            if #available(iOS 14.0, *) {
                // DisplayPriority: high marker = marker
                // zPriority: high marker > marker
                // 🐛 label zPriority not work, selected status label will overlap...
                marker.displayPriority = .required

                switch annotation.pinStyle {
                case .marker:
                    break
                case .highMarker:
                    #warning("Play zPriority")
                    marker.zPriority = .max
                }
            } else {
                // DisplayPriority: high marker > marker
                switch annotation.pinStyle {
                case .marker:
                    marker.displayPriority = .defaultHigh
                case .highMarker:
                    marker.displayPriority = .required
                }
            }
            // End here
            
            return marker
        }
    }
}

