//
//  ViewController.swift
//  PanelMap
//
//  Created by TK on 2021/11/16.
//

import UIKit
import SnapKit
import MapKit

class ViewController: UIViewController {
    private let mapView = MKMapView()
    private let contentViewController = ContentViewController()
    
    private lazy var panelViewController: PanelViewController = {
        let panelViewController = PanelViewController(backgroundView: mapView, contentViewController: contentViewController)
        contentViewController.scrollDelegate = panelViewController
        return panelViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        addChild(panelViewController)
        panelViewController.didMove(toParent: self)
        view.addSubview(panelViewController.view)
    }
}
