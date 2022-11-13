//
//  OTTableColumn.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public struct OTTableColumn<RowValue>
    where RowValue: Hashable, RowValue: Identifiable
{
    public var title: String
    public let id: OTTableColumnID
    public var isEditable: Bool = true
    public var isVisible: Bool = true
    internal var width: OTTableColumnWidth = .default
    
    var getValue: (_ rowItem: RowValue) -> Any?
    var setValue: ((_ row: Int, _ newValue: Any?) -> Void)?
    
    // MARK: Introspection
    
    public typealias IntrospectBlock = (
        _ tableColumn: NSTableColumn
    ) -> Void
    
    internal var introspectBlocks: [IntrospectBlock] = []
    
    // MARK: Init
    
    public init(
        title: String,
        id: OTTableColumnID? = nil,
        get getValue: @escaping (_ rowItem: RowValue) -> Any?,
        set setValue: ((_ row: Int, _ newValue: Any?) -> Void)? = nil
    ) {
        self.title = title
        self.id = id ?? OTTableColumnID(title)
        self.getValue = getValue
        self.setValue = setValue
    }
    
    public init(
        title: String,
        id: String,
        get getValue: @escaping (_ rowItem: RowValue) -> Any?,
        set setValue: ((_ row: Int, _ newValue: Any?) -> Void)? = nil
    ) {
        self.init(
            title: title,
            id: OTTableColumnID(id),
            get: getValue,
            set: setValue
        )
    }
}

// MARK: Types

extension OTTableColumn {
    internal enum OTTableColumnWidth {
        case `default`
        case fixed(CGFloat)
        case limits(min: CGFloat?, ideal: CGFloat?, max: CGFloat?)
    }
}

// MARK: View Modifiers

extension OTTableColumn {
    /// A generic introspection block that allows direct access to the table column object.
    public func introspect(
        _ block: @escaping IntrospectBlock
    ) -> Self {
        var copy = self
        copy.introspectBlocks.append(block)
        return copy
    }
    
    public func width(_ width: CGFloat) -> Self {
        var copy = self
        copy.width = .fixed(width)
        return copy
    }
    
    public func width(min: CGFloat?, ideal: CGFloat?, max: CGFloat?) -> Self {
        var copy = self
        copy.width = .limits(min: min, ideal: ideal, max: max)
        return copy
    }
    
    /// Sets the editable state for the column's row cells.
    /// Has no effect if no setter is provided at the time of column creation.
    public func editable(_ state: Bool) -> Self {
        var copy = self
        copy.isEditable = state
        return copy
    }
    
    public func visible(_ state: Bool) -> Self {
        var copy = self
        copy.isVisible = state
        return copy
    }
}
