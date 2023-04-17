//
//  WiFiSettingsViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-03.
//

import UIKit

class WiFiSettingsViewController: UIViewController {
    private enum Section: CaseIterable {
        case config, networks
    }

    private enum ItemType {
        case wifiEnabled, currentNetwork, availableNetwork
    }

    private struct WiFi: Hashable {
        private let identifier: UUID
        let title: String
        let type: ItemType
        let network: WiFiController.Network?

        init(title: String, status: ItemType) {
            self.title = title
            self.type = status
            self.network = nil
            self.identifier = UUID()
        }

        init(network: WiFiController.Network) {
            self.title = network.name
            self.type = .availableNetwork
            self.network = network
            self.identifier = network.identifier
        }

        var isConfig: Bool {
            let configItems: [ItemType] = [.currentNetwork, .wifiEnabled]
            return configItems.contains(type)
        }

        var isNetwork: Bool {
            return type == .availableNetwork
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, WiFi>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WiFi>

    private let wifiController: WiFiController
    private let collectionView: UICollectionView
    private let dataSource: DataSource

    private let wiFis = [
        WiFi(title: "Wi-Fi", status: .wifiEnabled),
        WiFi(title: "breeno-net", status: .currentNetwork),
    ]

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        wifiController = WiFiController()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.createLayout())
        dataSource = Self.configureDataSource(collectionView: collectionView)

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        wifiController.updateHandler =  { [weak self] in
            guard let self else { return }
            self.updateUI()
        }
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
        navigationItem.title = "Wi-Fi"
        collectionView.backgroundColor = .systemGray6
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
        return DataSource(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }

    private class func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(defaultSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private class func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, WiFi> {
        UICollectionView.CellRegistration<UICollectionViewListCell, WiFi> { cell, indexPath, wiFi in
            var content = cell.defaultContentConfiguration()
            if wiFi.isNetwork {
                content.text = wiFi.title
                cell.accessories = [.disclosureIndicator()]
            } else if wiFi.isConfig {
                content.text = wiFi.title
                if wiFi.type == .wifiEnabled {
                    let enableWifiSwitch = UISwitch()
                    enableWifiSwitch.isOn = true
                    enableWifiSwitch.addTarget(nil, action: #selector(toggleWifi(_:)), for: .touchUpInside)
                    let config = UICellAccessory.CustomViewConfiguration(customView: enableWifiSwitch, placement: .trailing())
                    cell.accessories = [UICellAccessory.customView(configuration: config)]
                } else {
                    cell.accessories = [.disclosureIndicator()]
                }
            }
            cell.contentConfiguration = content
        }
    }

    private func updateUI(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.config])
        snapshot.appendItems(wiFis)

        if wifiController.wifiEnabled {
            let sortedNetworks = wifiController.availableNetworks.sorted { $0.name < $1.name }
            let networkItems = sortedNetworks.map { WiFi(network: $0) }
            snapshot.appendSections([.networks])
            snapshot.appendItems(networkItems)
        }

        dataSource.apply(snapshot, animatingDifferences: true)

    }

    @objc private func toggleWifi(_ wifiEnabledSwitch: UISwitch) {
        wifiController.wifiEnabled = wifiEnabledSwitch.isOn
        updateUI()
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct WiFiSettingsViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                WiFiSettingsViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif


