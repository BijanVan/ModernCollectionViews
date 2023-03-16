//
//  GridViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-09.
//

import UIKit

class GridViewController: UIViewController {
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
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
        navigationItem.title = "Grid"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = Self.createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([Int](0..<94))
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<TextCell, Int> {
        UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier)"
            cell.contentView.backgroundColor = .systemGreen
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }

    /// - Tag: Grid
    private class func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct GridViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                GridViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
