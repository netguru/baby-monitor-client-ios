//
//  Lullaby.swift
//  Baby Monitor
//

enum BMLibraryEntry: String, CaseIterable {
    case hushLittleBaby
    case lullabyGoodnight
    case prettyLittleHorses
    case rockAByeBaby
    case twinkleTwinkleLittleStar
    
    static var allLullabies: [Lullaby] {
        return BMLibraryEntry.allCases.map { libraryEntry in
            return Lullaby(name: libraryEntry.name, identifier: libraryEntry.identifier, type: .bmLibrary)
        }
    }
    
    var name: String {
        switch self {
        case .hushLittleBaby:
            return Localizable.Lullabies.hushLittleBaby
        case .lullabyGoodnight:
            return Localizable.Lullabies.lullabyGoodnight
        case .prettyLittleHorses:
            return Localizable.Lullabies.prettyLittleHorses
        case .rockAByeBaby:
            return Localizable.Lullabies.rockAByeBaby
        case .twinkleTwinkleLittleStar:
            return Localizable.Lullabies.twinkleTwinkleLittleStar
        }
    }
    
    var identifier: String {
        return "rawValue"
    }
}

enum LullabyType: String {
    case bmLibrary
    case yourLullabies
}

struct Lullaby: Equatable {
    let name: String
    let identifier: String
    let type: LullabyType
}
