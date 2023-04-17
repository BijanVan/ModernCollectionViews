//
//  SectionBackgroundDecorationView.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-20.
//

import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func configure() {
        backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct SectionBackgroundDecorationView_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewPreview {
                return SectionBackgroundDecorationView()
            }.previewLayout(.sizeThatFits)
                .padding(50)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif
