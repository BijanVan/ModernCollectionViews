//
//  ListCell.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-10.
//

import UIKit

class BadgeSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "badge-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareSubviews()
        styleSubviews()
    }

    override func layoutSubviews() {
        configureBorder()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions
    private func prepareSubviews() {
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalTo: widthAnchor),
        ])
    }

    private func styleSubviews() {
        backgroundColor = .systemYellow
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
    }

    private func configureBorder() {
        let length = min(bounds.width, bounds.height)
        layer.cornerRadius = length / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct BadgeSupplementaryView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let cell = BadgeSupplementaryView()
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
