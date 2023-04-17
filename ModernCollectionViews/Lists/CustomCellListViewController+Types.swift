//
//  CustomCellListViewController+Types.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-04-12.
//

import UIKit

extension CustomCellListViewController {
    enum Section {
        case main
    }

    struct Category: Hashable {
        let icon: UIImage
        let name: String

        static let music = Category(icon: UIImage(systemName: "music.mic")!, name: "Music")
        static let transportation = Category(icon: UIImage(systemName: "car")!, name: "Transportation")
        static let weather = Category(icon: UIImage(systemName: "cloud.rain")!, name: "Weather")
    }

    struct Item: Hashable {
        private let identifier = UUID()
        let category: Category
        let image: UIImage
        let title: String
        let description: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: Item, rhs: Item) -> Bool { lhs.identifier == rhs.identifier }

        static let all = [
            Item(category: .music, image: UIImage(systemName: "headphones")!, title: "Headphones",
                 description: "A portable pair of earphones that are used to listen to music and other forms of audio."),
            Item(category: .music, image: UIImage(systemName: "hifispeaker.fill")!, title: "Loudspeaker",
                 description: "A device used to reproduce sound by converting electrical impulses into audio waves."),
            Item(category: .transportation, image: UIImage(systemName: "airplane")!, title: "Plane",
                 description: "A commercial airliner used for long distance travel."),
            Item(category: .transportation, image: UIImage(systemName: "tram.fill")!, title: "Tram",
                 description: "A trolley car used as public transport in cities."),
            Item(category: .transportation, image: UIImage(systemName: "car.fill")!, title: "Car",
                 description: "A personal vehicle with four wheels that is able to carry a small number of people."),
            Item(category: .weather, image: UIImage(systemName: "hurricane")!, title: "Hurricane",
                 description: "A tropical cyclone in the Caribbean with violent wind."),
            Item(category: .weather, image: UIImage(systemName: "tornado")!, title: "Tornado",
                 description: "A destructive vortex of swirling violent winds that advances beneath a large storm system."),
            Item(category: .weather, image: UIImage(systemName: "tropicalstorm")!, title: "Tropical Storm",
                 description: "A localized, intense low-pressure system, forming over tropical oceans."),
            Item(category: .weather, image: UIImage(systemName: "snow")!, title: "Snow",
                 description: "Atmospheric water vapor frozen into ice crystals falling in light flakes.")
        ]
    }
}
