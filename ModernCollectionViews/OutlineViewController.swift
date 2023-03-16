//
//  OutlineViewController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-09.
//

import UIKit

class OutlineViewController: UIViewController {
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSubviews()
        styleSubviews()

        navigationController?.pushViewController(ItemBadgeSupplementaryViewController(), animated: true)
    }

    // MARK: Private functions
    private func prepareSubviews() {
    }

    private func styleSubviews() {
    }
}

// MARK: Previews
#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
struct OutlineViewController_Preview: PreviewProvider {
    static let deviceNames: [String] = [
        "iPhone 14 Pro",
        "iPhone 13 mini",
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            UIViewControllerPreview {
                OutlineViewController()
            }.previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

#endif

