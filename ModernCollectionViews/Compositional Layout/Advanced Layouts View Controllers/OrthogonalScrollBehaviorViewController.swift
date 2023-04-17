//
//  GridViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-09.
//

import UIKit

class OrthogonalScrollBehaviorViewController: UIViewController {
    static let headerElementKind = "header-element-kind"

    enum SectionKind: Int, CaseIterable {
        case continuous, continuousGroupLeadingBoundary, paging, groupPaging, groupPagingCentered, none

        func orthogonalScrollingBehavior() -> UICollectionLayoutSectionOrthogonalScrollingBehavior {
            switch self {
            case .none:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.none
            case .continuous:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
            case .continuousGroupLeadingBoundary:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary
            case .paging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.paging
            case .groupPaging:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging
            case .groupPagingCentered:
                return UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered
            }
        }
    }

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
        navigationItem.title = "Orthogonal Section Behaviours"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }

    private func configureDataSource() {
        let cellRegistration = Self.createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }

        let headerRegistration = Self.createSupplementaryRegistration(dataSource: dataSource)
        dataSource.supplementaryViewProvider = { _, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        let itemsPerSection = 18
        var itemOffset = 0
        (0..<5).forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems([Int](itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<TextCell, Int> {
        UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier)"
            cell.contentView.backgroundColor = .systemGreen
            cell.contentView.layer.borderColor = UIColor.systemGray.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 8
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }

    private class func createSupplementaryRegistration(dataSource: UICollectionViewDiffableDataSource<Int, Int>) -> UICollectionView.SupplementaryRegistration<TitleSupplementaryView> {
        UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: Self.headerElementKind) { supplementaryView, elementKind, indexPath in
            let sectionKind = SectionKind(rawValue: indexPath.section)!
            supplementaryView.label.text = "." + String(describing: sectionKind)
        }
    }

    /// - Tag: OrthogonalBehavior
    private class func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        return UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else { fatalError("unknown section kind") }

            var itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0))
            let insets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let leadingItem = NSCollectionLayoutItem(layoutSize: itemSize)
            leadingItem.contentInsets = insets

            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
            let trailingItem = NSCollectionLayoutItem(layoutSize: itemSize)
            trailingItem.contentInsets = insets

            let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalWidth(1.0))
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize, repeatingSubitem: trailingItem, count: 2)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalWidth(1.0))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [leadingItem, trailingGroup])

            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = sectionKind.orthogonalScrollingBehavior()

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(defaultSize))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: Self.headerElementKind, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }, configuration: config)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct OrthogonalScrollBehaviorViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                OrthogonalScrollBehaviorViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
