//
//  Mock Data.swift
//  Demo
//
//  Created by Steffan Andrews on 2022-11-11.
//

import Foundation

struct TableItem: Equatable, Hashable, Identifiable {
    let id = UUID()
    var value: String
}

extension [TableItem] {
    static func mockItems() -> Self {
        (0 ... 20).map { .init(value: "Item \($0)") }
    }
}
