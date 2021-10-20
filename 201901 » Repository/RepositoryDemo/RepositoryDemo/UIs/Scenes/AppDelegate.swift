//
//  AppDelegate.swift
//  RepositoryDemo
//
//  Created by TING YEN KUO on 2019/1/27.
//  Copyright © 2019 TING YEN KUO. All rights reserved.
//

import UIKit
import ChainsKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        runApplication(with: JobListVC())
        
        return true
    }
    
    private func runApplication(with rootVC: UIViewController) {
        
        let nvc = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow()
            .rootViewController(nvc)
            .makeKeyAndVisibleWindow()
        
    }

}

