//
//  Mock Data.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
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
    
    public func matches(searchText: String) -> Bool {
        name.localizedCaseInsensitiveContains(searchText) ||
        kind.localizedCaseInsensitiveContains(searchText) ||
        comments.localizedCaseInsensitiveContains(searchText)
    }
}

extension [TableItem] {
    static func mockItems() -> Self {
        (0 ... 20).map {
            TableItem(
                name: "Item \($0)",
                kind: "Some kind",
                comments: "\(Int.random(in: 0 ... Int.max))"
            )
        }
    }
}
