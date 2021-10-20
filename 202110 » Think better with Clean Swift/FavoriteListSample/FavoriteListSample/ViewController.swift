//
//  ViewController.swift
//  MultipleSelectionSample
//
//  Created by TK on 2021/10/14.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let addButton = UIButton()
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        addButton.setTitle("新增股票", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 12
        addButton.clipsToBounds = true
        
        view.addSubview(addButton)        
        addButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150, height: 60))
            make.center.equalToSuperview()
        }
    }
    
    @objc func handleAdd() {
        let FavoriteListViewController = FavoriteListViewController(with: [
            .init(name: "台積電", symbol: "2330"),
            .init(name: "台灣 50", symbol: "0050"),
        ])
        let navigationController = UINavigationController(rootViewController: FavoriteListViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Helpers

protocol CellIdentifiable {
    static var reusableIdentifier: String { get }
}

extension CellIdentifiable {
    static var reusableIdentifier: String {
        .init(describing: type(of: self))
    }
}

extension UITableViewCell: CellIdentifiable { }
    
extension UIImage {
   static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
