//
//  CustomCellListViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-12.
//

import UIKit

class CustomCellListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var collectionView: UICollectionView
    private var dataSource: DataSource
    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout(appearance: .plain))
        dataSource = Self.configureDataSource(collectionView: collectionView)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        styleSubviews()
    }

    // MARK: Private functions
    private func prepareSubviews() {
        configureHierarchy()
    }

    private func styleSubviews() {
        navigationItem.title = "List with Custom Cells"
    }

    private func configureHierarchy() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    private class func configureDataSource(collectionView: UICollectionView) -> DataSource {
        let cellRegistration = Self.createCellRegistration()
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(Item.all)
        dataSource.apply(snapshot, animatingDifferences: false)

        return dataSource
    }

    private class func createLayout(appearance: UICollectionLayoutListConfiguration.Appearance) -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: appearance)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<CustomListCell, Item> {
        UICollectionView.CellRegistration<CustomListCell, Item> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            cell.item = item
            cell.accessories = [.disclosureIndicator()]
        }
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct CustomCellListViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                CustomCellListViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

