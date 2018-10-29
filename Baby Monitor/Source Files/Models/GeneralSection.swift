//
//  GeneralSection.swift
//  Baby Monitor
//

import RxDataSources

struct GeneralSection<T> {
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
