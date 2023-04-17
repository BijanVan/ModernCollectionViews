//
//  WiFiController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-03.
//

import Foundation

class WiFiController {
    struct Network: Hashable, Equatable {
        let identifier = UUID()
        let name: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: Network, rhs: Network) -> Bool {
            lhs.identifier == rhs.identifier
        }
    }

    typealias UpdateHandler = () -> ()

    init() {
        updateNetworks()
    }

    var wifiEnabled = true
    var updateHandler: UpdateHandler?

    private(set) var availableNetworks = [Network]()
    private let updateInterval = 2.0

    private func updateNetworks() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + updateInterval) { [weak self] in
            guard let self else { return }
            availableNetworks = []
            let count = Int.random(in: 0..<allNetworks.count)
            let start = Int.random(in: 0..<(allNetworks.count - count))
            for i in start..<start + count {
                availableNetworks.append(self.allNetworks[i])
            }
            if let updateHandler {
                updateHandler()
            }
            updateNetworks()
        }
    }

    private let allNetworks = [ Network(name: "AirSpace1"),
                                Network(name: "Living Room"),
                                Network(name: "Courage"),
                                Network(name: "Nacho WiFi"),
                                Network(name: "FBI Surveillance Van"),
                                Network(name: "Peacock-Swagger"),
                                Network(name: "GingerGymnist"),
                                Network(name: "Second Floor"),
                                Network(name: "Evergreen"),
                                Network(name: "__hidden_in_plain__sight__"),
                                Network(name: "MarketingDropBox"),
                                Network(name: "HamiltonVille"),
                                Network(name: "404NotFound"),
                                Network(name: "SNAGVille"),
                                Network(name: "Overland101"),
                                Network(name: "TheRoomWiFi"),
                                Network(name: "PrivateSpace")
    ]
}
