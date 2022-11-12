//
//  OTTableColumn.swift
//  OTTableView
//

import AppKit
import SwiftUI

public struct OTTableColumn {
    public var title: String
    @Binding public var isVisible: Bool
    internal var _width: OTTableColumnWidth?
    
    public init(name: String, isVisible: Binding<Bool> = .constant(true)) {
        self.title = name
        self._isVisible = isVisible
    }
}

// MARK: Types

extension OTTableColumn {
    internal enum OTTableColumnWidth {
        case exact(CGFloat)
        case limits(min: CGFloat?, ideal: CGFloat?, max: CGFloat?)
    }
}

// MARK: View Modifiers

extension OTTableColumn {
    public func width(_ width: CGFloat) -> Self {
        var copy = self
        copy._width = .exact(width)
        return copy
    }
    
    public func width(min: CGFloat?, ideal: CGFloat?, max: CGFloat?) -> Self {
        var copy = self
        copy._width = .limits(min: min, ideal: ideal, max: max)
        return copy
    }
}
