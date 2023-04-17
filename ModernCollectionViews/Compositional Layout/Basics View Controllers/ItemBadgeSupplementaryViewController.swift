//
//  DistinctSectionsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-11.
//

import UIKit

class ItemBadgeSupplementaryViewController: UIViewController {
    static let badgeElementKind = "badge-element-kind"
    enum Section {
        case main
    }

    struct Model: Hashable {
        let id = UUID()
        let title: String
        let badgeCount: Int

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Model>!
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
        navigationItem.title = "Item Badges"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let textCellRegistration = Self.createTextCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: itemIdentifier)
        }
        let supplementaryRegistration = Self.createSupplementaryRegistration(dataSource: dataSource)
        dataSource.supplementaryViewProvider = { _, _, indexPath in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = (0..<100).map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private class func createTextCellRegistration() -> UICollectionView.CellRegistration<TextCell, Model> {
        UICollectionView.CellRegistration<TextCell, Model> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier.title)"
            cell.contentView.backgroundColor = .systemGreen
            cell.contentView.layer.borderColor = UIColor.systemGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }

    private class func createSupplementaryRegistration(dataSource: UICollectionViewDiffableDataSource<Section, Model>) -> UICollectionView.SupplementaryRegistration<BadgeSupplementaryView> {
        UICollectionView.SupplementaryRegistration<BadgeSupplementaryView>(elementKind: BadgeSupplementaryView.reuseIdentifier) { supplementaryView, elementKind, indexPath in
            guard let model = dataSource.itemIdentifier(for: indexPath) else { return }
            supplementaryView.label.text = "\(model.badgeCount)"
            supplementaryView.isHidden = model.badgeCount == 0
        }
    }

    /// - Tag: Badge
    private class func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: BadgeSupplementaryView.reuseIdentifier, containerAnchor: badgeAnchor)


        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct ItemBadgeSupplementaryViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                ItemBadgeSupplementaryViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
