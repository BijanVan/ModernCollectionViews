//
//  DistinctSectionsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-11.
//

import UIKit

class SectionDecorationViewController: UIViewController {
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"

    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>!
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
        navigationItem.title = "Section Background Decoration View"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        let itemsPerSection = 5
        var itemOffset = 0
        (0..<5).forEach {
            currentSnapshot.appendSections([$0])
            currentSnapshot.appendItems([Int](itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }

        let cellRegistration = Self.createCellRegistration(snapshot: currentSnapshot)
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }

    private class func createCellRegistration(snapshot: NSDiffableDataSourceSnapshot<Int, Int>) -> UICollectionView.CellRegistration<ListCell, Int> {
        UICollectionView.CellRegistration<ListCell, Int> { cell, indexPath, itemIdentifier in
            let sectionIdentifier = snapshot.sectionIdentifiers[indexPath.section]
            let numberOfItemsInSection = snapshot.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numberOfItemsInSection
            cell.label.text = "\(indexPath.section),\(indexPath.item)"
            cell.separatorView.isHidden = isLastCell
        }
    }

    /// - Tag: Background
    private class func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(defaultSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: Self.sectionBackgroundDecorationElementKind)
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [sectionBackgroundDecoration]

        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SectionDecorationViewController.sectionBackgroundDecorationElementKind)
        return layout
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct SectionDecorationViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                SectionDecorationViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
