//
//  CustomCellListViewController+CustomListCell.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-12.
//

import UIKit

private extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("com.my.ItemListCell.item")
}

private extension UICellConfigurationState {
    var item: CustomCellListViewController.Item? {
        set { self[.item] = newValue }
        get { return self[.item] as? CustomCellListViewController.Item }
    }
}

extension CustomCellListViewController {
    class CustomListCell: UICollectionViewListCell {
        private let listContentView = UIListContentView(configuration: .subtitleCell())
        private let categoryIconView = UIImageView()
        private let categoryLabel = UILabel()

        private var categoryLabelLeading: NSLayoutConstraint?
        private var categoryLabelTrailing: NSLayoutConstraint?
        private var categoryIconTrailing: NSLayoutConstraint?
        private var separatorConstraint: NSLayoutConstraint?
        private var areSubviewsPrepared = false

        var _item: Item?
        var item: Item? {
            get { return _item }
            set {
                if newValue == _item { return }
                _item = newValue
                setNeedsUpdateConfiguration()
            }
        }

        // MARK: Overrides
        override var configurationState: UICellConfigurationState {
            var state = super.configurationState
            state.item = item
            return state
        }

        override func updateConfiguration(using state: UICellConfigurationState) {
            prepareSubviews()

            var content = UIListContentConfiguration.subtitleCell().updated(for: state)
            content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
            content.image = state.item?.image
            content.text = state.item?.title
            content.secondaryText = state.item?.description
            content.axesPreservingSuperviewLayoutMargins = []
            listContentView.configuration = content

            let valueConfiguration = UIListContentConfiguration.valueCell().updated(for: state)
            categoryIconView.image = state.item?.category.icon
            categoryIconView.tintColor = valueConfiguration.imageProperties.resolvedTintColor(for: tintColor)
            categoryIconView.preferredSymbolConfiguration = .init(font: valueConfiguration.secondaryTextProperties.font, scale: .small)

            categoryLabel.text = state.item?.category.name
            categoryLabel.textColor = valueConfiguration.secondaryTextProperties.resolvedColor()
            categoryLabel.font = valueConfiguration.secondaryTextProperties.font
            categoryLabel.adjustsFontForContentSizeCategory = valueConfiguration.secondaryTextProperties.adjustsFontForContentSizeCategory

            categoryLabelLeading?.constant = content.directionalLayoutMargins.trailing
            categoryLabelTrailing?.constant = valueConfiguration.textToSecondaryTextHorizontalPadding
            categoryIconTrailing?.constant = content.directionalLayoutMargins.trailing
            updateSeparatorConstraint()
        }

        // MARK: Private functions
        private func prepareSubviews() {
            guard !areSubviewsPrepared else { return }

            listContentView.translatesAutoresizingMaskIntoConstraints = false
            categoryIconView.translatesAutoresizingMaskIntoConstraints = false
            categoryLabel.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(listContentView)
            contentView.addSubview(categoryLabel)
            contentView.addSubview(categoryIconView)

            listContentView.setContentCompressionResistancePriority(.defaultBelowHigh, for: .horizontal)

            categoryLabelLeading = categoryLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor)
            categoryLabelTrailing = categoryIconView.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor)
            categoryIconTrailing = contentView.trailingAnchor.constraint(equalTo: categoryIconView.trailingAnchor)

            NSLayoutConstraint.activate([
                listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
                listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                categoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                categoryIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                categoryLabelLeading!,
                categoryLabelTrailing!,
                categoryIconTrailing!,
            ])

            areSubviewsPrepared = true
        }

        private func updateSeparatorConstraint() {
            guard let textLayoutGuide = listContentView.textLayoutGuide else { return }
            if let existingConstraint = separatorConstraint, existingConstraint.isActive { return }

            let constraint = separatorLayoutGuide.leadingAnchor.constraint(equalTo: textLayoutGuide.leadingAnchor)
            constraint.isActive = true
            separatorConstraint = constraint
        }
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

fileprivate typealias Item = CustomCellListViewController.Item
fileprivate typealias CustomListCell = CustomCellListViewController.CustomListCell

@available(iOS 13.0, *)
struct CustomListCell_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let cell = CustomListCell()
                cell.item = Item(category: .weather, image: UIImage(systemName: "snow")!, title: "Snow", description: "Atmospheric water vapor frozen into ice crystals falling in light flakes.")

                return cell
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

