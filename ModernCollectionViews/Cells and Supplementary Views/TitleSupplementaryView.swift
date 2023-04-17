//
//  TitleSupplementaryView.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-17.
//

import UIKit

class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "title-supplementary-reuse-identifier"
    let label = UILabel()

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

        addSubview(label)

        let inset = 10.0
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
        ])
    }

    private func styleSubviews() {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title3)
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct TitleSupplementaryView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                let view = TitleSupplementaryView()
                view.label.text = "123"
                view.backgroundColor = .systemGray
                return view
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

