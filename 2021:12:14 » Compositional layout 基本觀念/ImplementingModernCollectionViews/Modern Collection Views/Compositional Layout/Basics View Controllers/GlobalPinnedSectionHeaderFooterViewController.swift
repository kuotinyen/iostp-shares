//
//  GlobalPinnedSectionHeaderFooterViewController.swift
//  Modern Collection Views
//
//  Created by TK on 2021/12/11.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class GlobalPinnedSectionHeaderFooterViewController: UIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pinned Section Headers"
        configureHierarchy()
        configureDataSource()
    }
}

extension GlobalPinnedSectionHeaderFooterViewController {
    /// - Tag: PinnedHeader
    func createLayout() -> UICollectionViewLayout {
        let leadingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                              heightDimension: .fractionalHeight(1.0)))
        leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let trailingItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.3)))
        trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0)),
            subitem: trailingItem, count: 2)

        let containerGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                              heightDimension: .fractionalHeight(0.4)),
            subitems: [leadingItem, trailingGroup])

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind,
            alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(44)),
            elementKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind,
            alignment: .bottom)
//        sectionHeader.pinToVisibleBounds = true // will not trigger
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), elementKind: DemoGlobalHeader.elementKind, alignment: .top)
        globalHeader.pinToVisibleBounds = true
//        globalHeader.zIndex = 2
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        layout.configuration = config
        
        return layout
    }
}

extension GlobalPinnedSectionHeaderFooterViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    /// - Tag: PinnedHeaderRegistration
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            // Populate the cell with our item description.
            cell.label.text = "\(indexPath.section), \(indexPath.item)"
            cell.contentView.backgroundColor = .cornflowerBlue
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        let globalHeaderRegistration = UICollectionView.SupplementaryRegistration
        <DemoGlobalHeader>(elementKind: DemoGlobalHeader.elementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.backgroundColor = .systemBlue
            
            supplementaryView.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHeader))
            supplementaryView.addGestureRecognizer(tapRecognizer)
            
            supplementaryView.populate(text: "\(string) for global section")
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: PinnedSectionHeaderFooterViewController.sectionHeaderElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(string) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: PinnedSectionHeaderFooterViewController.sectionFooterElementKind) {
            (supplementaryView, string, indexPath) in
            supplementaryView.label.text = "\(string) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
            
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            // Return the cell.
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            if kind == DemoGlobalHeader.elementKind {
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: globalHeaderRegistration, for: index)
            } else {
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: kind == PinnedSectionHeaderFooterViewController.sectionHeaderElementKind ? headerRegistration : footerRegistration, for: index)
            }
        }

        // initial data
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc func tapHeader() {
        print("#### tapHeader")
    }
}

extension GlobalPinnedSectionHeaderFooterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - TK

class DemoGlobalHeader: CollectionGlobalHeader {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func populate(text: String) {
        textLabel.text = text
    }
}

class CollectionGlobalHeader: UICollectionReusableView {
    static var elementKind: String { "CollectionGlobalHeader" }
    static var reuseIdentifier: String { elementKind }

    // Workaround for iOS 13 / 14 header issue, Ref: https://github.com/gspiers/FB8722886
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutAttributes.zIndex = .max
        super.apply(layoutAttributes)
        
//        frame = layoutAttributes.frame
//        layer.isHidden = layoutAttributes.isHidden
    }
}

class GlobalHeaderCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()

        let attributes = collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: CollectionGlobalHeader.elementKind, at: IndexPath(indexes: [0]))

        let firstLayoutHeader = subviews.first { $0 is CollectionGlobalHeader }
        
        if let globalHeader = firstLayoutHeader as? CollectionGlobalHeader {
            bringSubviewToFront(globalHeader)
            
            if let attributes = attributes {
                globalHeader.apply(attributes)
            }
        }

//        // Even if UIKit fixes this we should only be applying the attributes twice in the worse case.
//        if let reuseableView = firstLayoutHeader as? UICollectionReusableView, let attributes = attributes {
//            reuseableView.apply(attributes)
//        }
    }
}
