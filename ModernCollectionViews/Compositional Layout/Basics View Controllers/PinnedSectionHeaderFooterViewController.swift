//
//  DistinctSectionsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-11.
//

import UIKit

class PinnedSectionHeaderFooterViewController: UIViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
    static let sectionFooterElementKind = "section-footer-element-kind"

    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        styleSubviews()
    }

    // MARK: Private functions
    private func prepareSubviews() {
        configureHierarchy()
        configureDataSource()
    }

    private func styleSubviews() {
        navigationItem.title = "Pinned Section Headers/Footers"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let textCellRegistration = Self.createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: itemIdentifier)
        }

        let headerRegistration = Self.createSupplementaryRegistration(dataSource: dataSource, elementKind: Self.sectionHeaderElementKind)
        let footerRegistration = Self.createSupplementaryRegistration(dataSource: dataSource, elementKind: Self.sectionFooterElementKind)

        dataSource.supplementaryViewProvider = { _, kind, indexPath in
            let registration = kind == Self.sectionHeaderElementKind ? headerRegistration : footerRegistration
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: registration, for: indexPath)
        }


        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        let itemsPerSection = 5
        var itemOffset = 0

        (0..<5).forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems([Int](itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<ListCell, Int> {
        UICollectionView.CellRegistration<ListCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(indexPath.section),\(indexPath.item)"
        }
    }

    private class func createSupplementaryRegistration(dataSource: UICollectionViewDiffableDataSource<Int, Int>, elementKind: String) -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: elementKind) { supplementaryView, elementKind, indexPath in
            supplementaryView.label.text = "\(elementKind) for section \(indexPath.section)"
            supplementaryView.backgroundColor = .lightGray
            supplementaryView.layer.borderColor = UIColor.black.cgColor
            supplementaryView.layer.borderWidth = 1.0
        }
    }

    /// - Tag: HeaderFooter
    private class func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(defaultSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let headerFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(defaultSize))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Self.sectionHeaderElementKind, alignment: .top)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2

        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerFooterSize, elementKind: Self.sectionFooterElementKind, alignment: .bottom)

        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct PinnedSectionHeaderFooterViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                PinnedSectionHeaderFooterViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
