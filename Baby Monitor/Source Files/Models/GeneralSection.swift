//
//  GeneralSection.swift
//  Baby Monitor
//

import RxDataSources

struct GeneralSection<T: Equatable>: Equatable {
    var title: String
    var items: [T]
}

extension GeneralSection: SectionModelType {
    
    typealias Item = T
    
    init(original: GeneralSection, items: [Item]) {
        self = original
        self.items = items
    }
}
