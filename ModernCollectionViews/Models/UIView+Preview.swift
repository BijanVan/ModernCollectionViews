//
//  UIView+Preview.swift
//  Earthquakes
//
//  Created by Bijan Nazem on 2023-01-28.
//

import UIKit
import SwiftUI

@available(iOS 13, *)
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
    public let view: View
    
    public init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    public func makeUIView(context: Context) -> UIView {
        return view
    }
    
    public func updateUIView(_ view: UIView, context: Context) {
//        view.setContentHuggingPriority(.defaultBelowLow, for: .horizontal)
//        view.setContentHuggingPriority(.defaultBelowLow, for: .vertical)
//        view.setContentCompressionResistancePriority(.defaultBelowHigh, for: .horizontal)
//        view.setContentCompressionResistancePriority(.defaultBelowHigh, for: .vertical)
    }
}
