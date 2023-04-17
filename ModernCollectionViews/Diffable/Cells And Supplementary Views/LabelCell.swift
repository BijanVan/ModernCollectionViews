//
//  LabelCell.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-24.
//

import UIKit

class LabelCell: UICollectionViewCell {
    static let reuseIdentifier = "label-cell-reuse-identifier"
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
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
struct LabelCell_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let cell = LabelCell()
                //                cell.label.text = "123"
                return cell
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif



