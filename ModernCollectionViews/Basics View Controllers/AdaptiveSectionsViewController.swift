//
//  DistinctSectionsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-11.
//

import UIKit

class AdaptiveSectionsViewController: UIViewController {
    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 700
            switch self {
            case .grid3:
                return wideMode ? 6 : 3

            case .grid5:
                return wideMode ? 10 : 5

            case .list:
                return wideMode ? 2 : 1
            }
        }
    }

    var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>!
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
        navigationItem.title = "Adaptive Sections"
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Self.createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self
    }

    private func configureDataSource() {
        let textCellRegistration = Self.createTextCellRegistration()
        let listCellRegistration = Self.createListCellRegistration()

        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) in
            return SectionLayoutKind(rawValue: indexPath.section)! == .list ?
            collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier) :
            collectionView.dequeueConfiguredReusableCell(using: textCellRegistration, for: indexPath, item: itemIdentifier)
        }

        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperBound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset..<itemUpperBound))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private class func createTextCellRegistration() -> UICollectionView.CellRegistration<TextCell, Int> {
        UICollectionView.CellRegistration<TextCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier)"
            cell.contentView.backgroundColor = .systemGreen
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = SectionLayoutKind(rawValue: indexPath.section)! == .grid5 ? 8 : 0
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
    }

    private class func createListCellRegistration() -> UICollectionView.CellRegistration<ListCell, Int> {
        UICollectionView.CellRegistration<ListCell, Int> { cell, indexPath, itemIdentifier in
            cell.label.text = "\(itemIdentifier)"
        }
    }

    /// - Tag: Adaptive
    private class func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let effectiveWidth = layoutEnvironment.container.effectiveContentSize.width
            let columnCount = sectionLayoutKind.columnCount(for: effectiveWidth)

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(columnCount)), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight = columnCount == 1 ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columnCount)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

            return section
        }
    }
}

extension AdaptiveSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct AdaptiveSectionsViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                AdaptiveSectionsViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
