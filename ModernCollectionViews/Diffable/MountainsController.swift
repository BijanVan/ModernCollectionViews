//
//  MountainsController.swift
//  ModernCollectionViews
//
//  Created by Bijan Nazem on 2023-03-22.
//

import Foundation

class MountainsController {
    struct Mountain: Hashable, Equatable {
        let name: String
        let height: Int
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    func filtered(by term: String?) -> LazyFilterSequence<[Mountain]> {
        guard let term else { return mountains.lazy.filter({ _ in true }) }
        return mountains.lazy.filter({ $0.name.lowercased().contains(term.lowercased()) })
    }

    private lazy var mountains = generateMountains()

    private func generateMountains() -> [Mountain] {
        return mountainsRawData.components(separatedBy:CharacterSet.newlines).map({
            let elements = $0.components(separatedBy: ",")
            return Mountain(name: elements[0], height: Int(elements[1]) ?? 0)
        })
    }
}
