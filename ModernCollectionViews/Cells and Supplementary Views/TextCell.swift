//
//  TextCell.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-10.
//

import UIKit

class TextCell: UICollectionViewCell {
    static let reuseIdentifier = "text-cell-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultSpacing),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultSpacing),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: defaultSpacing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -defaultSpacing)
        ])
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct TextCell_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let cell = TextCell()
                cell.label.text = "123"
                cell.contentView.backgroundColor = .systemGreen
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 1
                cell.label.textAlignment = .center
                cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
                return cell
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
