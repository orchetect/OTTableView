//
//  OTTableColumnID.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public struct OTTableColumnID: Equatable, Hashable, Identifiable {
    public let stringValue: String
    
    public var id: NSUserInterfaceItemIdentifier {
        .init(stringValue)
    }
    
    public init(_ stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init(_ id: NSUserInterfaceItemIdentifier) {
        self.stringValue = id.rawValue
    }
    
    public init(for column: NSTableColumn) {
        self.stringValue = column.identifier.rawValue
    }
}

extension OTTableColumnID {
    /// Returns a new instance with a unique random identifier.
    public func random() -> Self {
        OTTableColumnID(UUID().uuidString)
    }
}

// MARK: Extensions

extension OTTableView {
    /// Returns the current table column order as a sequence of IDs.
    public var tableColumnIDs: [OTTableColumnID] {
        tableColumns.map { OTTableColumnID(for: $0) }
    }
    
    public func tableColumn(withIdentifier identifier: OTTableColumnID) -> NSTableColumn? {
        tableColumns.first(where: {
            $0.identifier == identifier.id
        })
    }
}

extension NSTableColumn {
    public var otTableColumnID: OTTableColumnID {
        OTTableColumnID(for: self)
    }
}

extension [NSTableColumn] {
    public func firstIndex(withIdentifier id: OTTableColumnID) -> Index? {
        indices.first(where: { self[$0].identifier == id.id })
    }
    
    public func first(withIdentifier id: OTTableColumnID) -> Element? {
        guard let idx = firstIndex(withIdentifier: id) else { return nil }
        return self[idx]
    }
}

extension Collection where Element == OTTableColumnID {
    public func firstIndex(matching column: NSTableColumn) -> Index? {
        firstIndex(where: { column.identifier == $0.id })
    }
    
    public func first(matching column: NSTableColumn) -> Element? {
        guard let idx = firstIndex(matching: column) else { return nil }
        return self[idx]
    }
}

extension Collection {
    public func firstIndex<T: Hashable & Equatable>(
        matching column: NSTableColumn
    ) -> Index?
    where Element == OTTableColumn<T>
    {
        firstIndex(where: { column.identifier == $0.id.id })
    }
    
    public func first<T: Hashable & Equatable>(
        matching column: NSTableColumn
    ) -> Element?
    where Element == OTTableColumn<T>
    {
        guard let idx = firstIndex(matching: column) else { return nil }
        return self[idx]
    }
}
