//
//  OTTableView.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public class OTTableView<RowValue>: NSTableView, NSTableViewDelegate, NSTableViewDataSource
    where RowValue: Hashable, RowValue: Identifiable
{
    public var axes: Axis.Set = [.horizontal, .vertical]
    
    internal var contents: [RowValue] = []
    internal var selection: Set<RowValue.ID> = []
    internal var columns: [OTTableColumn<RowValue>] = []
    
    // MARK: NSTableViewDelegate
    
//    public func tableView(
//        _ tableView: NSTableView,
//        heightOfRow row: Int
//    ) -> CGFloat {}
    
//    public func tableViewColumnDidResize(_ notification: Notification) {}
    
    // MARK: NSTableViewDataSource
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        contents.count
    }
    
//    public func tableView(_ tableView: NSTableView,
//                          viewFor tableColumn: NSTableColumn?,
//                          row: Int) -> NSView? {
//        guard let tableColumn else { return nil }
//        guard let idx = Int(tableColumn.identifier.rawValue) else { return nil }
//        guard columns.indices.contains(idx) else { return nil }
//
//        let cellView = columns[idx].cellView(contents[row])
//
//        return NSHostingView(rootView: AnyView(cellView))
//    }
    
    public func tableView(
        _ tableView: NSTableView,
        objectValueFor tableColumn: NSTableColumn?,
        row: Int
    ) -> Any? {
        guard let tableColumn else { return nil }
        
        return columns
            .first(matching: tableColumn)?
            .getValue(contents[row])
    }
    
    public func tableView(
        _ tableView: NSTableView,
        setObjectValue object: Any?,
        for tableColumn: NSTableColumn?,
        row: Int
    ) {
        guard let tableColumn else { return }
        
        columns
            .first(matching: tableColumn)?
            .setValue?(row, object)
    }
    
    // MARK: NSView Overrides
    
    // overriding this allows the scroll axes to be constrained
    public override func adjustScroll(_ newVisible: NSRect) -> NSRect {
        if axes == [.horizontal, .vertical] {
            return super.adjustScroll(newVisible)
        }
        
        var newRect = newVisible
        if !axes.contains(.horizontal) {
            newRect.origin.x = bounds.origin.x
        }
        
        if !axes.contains(.vertical) {
            newRect.origin.y = bounds.origin.y
        }
        
        return newRect
    }
}
