//
//  MountainsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-21.
//

import UIKit


class MountainsViewController: UIViewController, UISearchBarDelegate {
    enum Section: CaseIterable {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MountainsController.Mountain>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MountainsController.Mountain>

    let mountainsController: MountainsController
    let stackView = UIStackView()
    let searchBar = UISearchBar()
    let collectionView: UICollectionView
    let dataSource: DataSource

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        mountainsController = MountainsController()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout())
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
        navigationItem.title = "Mountains Search"

        stackView.axis = .vertical
        searchBar.placeholder = "Filter..."
        searchBar.delegate = self

        performQuery(searchText: nil)
    }

    private func configureHierarchy() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(collectionView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: guide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    private class func configureDataSource(collectionView: UICollectionView) -> DataSource {
        let cellRegistration = Self.createCellRegistration()
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    private class func createLayout() -> UICollectionViewLayout {
        let columnCount = 2
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / CGFloat(columnCount)), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(defaultSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: columnCount)
        group.interItemSpacing = .fixed(defaultSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = defaultSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
        return UICollectionViewCompositionalLayout(section: section)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<LabelCell, MountainsController.Mountain> {
        UICollectionView.CellRegistration<LabelCell, MountainsController.Mountain> { cell, indexPath, mountain in
            cell.label.text = mountain.name
        }
    }

    private func performQuery(searchText: String?) {
        let mountains = mountainsController.filtered(by: searchText).sorted { $0.name < $1.name }
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(mountains)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(searchText: searchText)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct MountainsViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                MountainsViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

