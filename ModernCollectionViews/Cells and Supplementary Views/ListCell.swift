//
//  ListCell.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-10.
//

import UIKit

class ListCell: UICollectionViewCell {
    static let reuseIdentifier = "list-cell-reuse-identifier"
    let label = UILabel()
    let accessoryView = UIImageView()
    let separatorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareSubviews()
        styleSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions
    private func prepareSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(label)
        contentView.addSubview(accessoryView)
        contentView.addSubview(separatorView)

        let inset = 10.0

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            label.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -inset),
        ])

        NSLayoutConstraint.activate([
            accessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
        ])

        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }

    private func styleSubviews() {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)

        separatorView.backgroundColor = .systemGray2

        let chevronImageName = effectiveUserInterfaceLayoutDirection == .rightToLeft ? "chevron.left" : "chevron.right"
        accessoryView.image = UIImage(systemName: chevronImageName)
        accessoryView.tintColor = .systemGray2.withAlphaComponent(0.7)

        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemGray2.withAlphaComponent(0.3)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct ListCell_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let cell = ListCell()
                cell.label.text = "123"
                return cell
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
