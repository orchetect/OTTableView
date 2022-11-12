//
//  OTTableColumn.swift
//  OTTableView
//

import AppKit
import SwiftUI

public struct OTTableColumn<RowValue>
where RowValue: Hashable,
      RowValue: Identifiable
{
    public var title: String
    public var isVisible: Bool = true
    internal var width: OTTableColumnWidth = .default
    
    var getValue: (_ rowItem: RowValue) -> Any?
    var setValue: ((_ row: Int, _ newValue: Any?) -> ())?
    
    public init(title: String,
                get getValue: @escaping (_ rowItem: RowValue) -> Any?,
                set setValue: ((_ row: Int, _ newValue: Any?) -> ())? = nil
    ) {
        self.title = title
        self.getValue = getValue
        self.setValue = setValue
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
    
    public func visible(_ state: Bool) -> Self {
        var copy = self
        copy.isVisible = state
        return copy
    }
}
