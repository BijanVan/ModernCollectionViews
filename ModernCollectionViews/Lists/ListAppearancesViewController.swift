//
//  ListAppearancesViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-09.
//

import UIKit

class ListAppearancesViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    private var collectionView: UICollectionView
    private var dataSource: DataSource
    private var appearance = UICollectionLayoutListConfiguration.Appearance.plain

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout(appearance: .plain))
        dataSource = Self.configureDataSource(collectionView: collectionView, appearance: .plain)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        styleSubviews()
        updateBarButtonItem()
    }

    // MARK: Private functions
    private func prepareSubviews() {
        configureHierarchy()
    }

    private func styleSubviews() {
        navigationItem.title = "List Appearances"
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

    private class func configureDataSource(collectionView: UICollectionView, appearance: UICollectionLayoutListConfiguration.Appearance) -> DataSource {
        let headerRegistration = Self.createHeaderRegistration()
        let cellRegistration = Self.createCellRegistration(appearance: appearance)
        let dataSource = DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            if indexPath.item == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: itemIdentifier)
            } else {
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
        }

        var snapshot = Snapshot()
        let sections = [Int](0..<5)
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        for section in sections {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<String>()
            let headerItem = "Section \(section)"
            sectionSnapshot.append([headerItem])
            let items = Array(0..<3).map { "Item \(section)-\($0)" }
            sectionSnapshot.append(items, to: headerItem)
            sectionSnapshot.expand([headerItem])
            dataSource.apply(sectionSnapshot, to: section)
        }

        return dataSource
    }

    private class func createLayout(appearance: UICollectionLayoutListConfiguration.Appearance) -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: appearance)
        config.headerMode = .firstItemInSection
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    private class func createCellRegistration(appearance: UICollectionLayoutListConfiguration.Appearance) -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
            switch appearance {
            case .sidebar, .sidebarPlain:
                cell.accessories = []
            default:
                cell.accessories = [.disclosureIndicator()]
            }
        }
    }

    private class func createHeaderRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
            cell.accessories = [.outlineDisclosure()]
        }
    }

    @objc private func changeListAppearance() {
        switch appearance {
        case .plain:
            appearance = .sidebarPlain
        case .sidebarPlain:
            appearance = .sidebar
        case .sidebar:
            appearance = .grouped
        case .grouped:
            appearance = .insetGrouped
        case .insetGrouped:
            appearance = .plain
        default:
            break
        }

        collectionView.removeFromSuperview()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout(appearance: appearance))
        dataSource = Self.configureDataSource(collectionView: collectionView, appearance: appearance)
        configureHierarchy()
        updateBarButtonItem()
    }

    private func updateBarButtonItem() {
        var title: String? = nil
        switch appearance {
        case .plain: title = "Plain"
        case .sidebarPlain: title = "Sidebar Plain"
        case .sidebar: title = "Sidebar"
        case .grouped: title = "Grouped"
        case .insetGrouped: title = "Inset Grouped"
        default: break
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(changeListAppearance))
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct ListAppearancesViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                ListAppearancesViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif



