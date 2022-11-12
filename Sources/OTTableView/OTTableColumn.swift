//
//  OTTableColumn.swift
//  OTTableView
//

import AppKit
import SwiftUI

public struct OTTableColumn {
    public var title: String
    @Binding public var isVisible: Bool
    internal var width: OTTableColumnWidth = .default
    
    public init(name: String, isVisible: Binding<Bool> = .constant(true)) {
        self.title = name
        self._isVisible = isVisible
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
}
