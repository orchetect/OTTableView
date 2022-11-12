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
        guard let idx = Int(tableColumn.identifier.rawValue) else { return nil }
        guard columns.indices.contains(idx) else { return nil }
        
        let cellValue = columns[idx].getValue(contents[row])
        
        return cellValue
    }
    
    public func tableView(
        _ tableView: NSTableView,
        setObjectValue object: Any?,
        for tableColumn: NSTableColumn?,
        row: Int
    ) {
        guard let tableColumn else { return }
        guard let idx = Int(tableColumn.identifier.rawValue) else { return }
        guard columns.indices.contains(idx) else { return }
        
        columns[idx].setValue?(row, object)
    }
}
