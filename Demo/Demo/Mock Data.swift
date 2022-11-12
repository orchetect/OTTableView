//
//  Mock Data.swift
//  Demo
//
//  Created by Steffan Andrews on 2022-11-11.
//

import Foundation

struct TableItem: Equatable, Hashable, Identifiable {
    let id = UUID()
    var name: String
    var kind: String
    var comments: String
}

extension TableItem {
    static func newItem() -> Self {
        .init(name: "New Item", kind: "", comments: "")
    }
}

extension [TableItem] {
    static func mockItems() -> Self {
        (0 ... 20).map {
            .init(name: "Item \($0)", kind: "Some kind", comments: "\(Int.random(in: 0...Int.max))")
        }
    }
}
