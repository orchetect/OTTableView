//
//  OTTableView.swift
//  OTTableView
//

import AppKit
import SwiftUI

public class OTTableView<RowValue>: NSTableView, NSTableViewDelegate, NSTableViewDataSource
where RowValue: Hashable,
      RowValue: Identifiable
{
    internal var contents: [RowValue] = []
    internal var selection: Set<RowValue.ID> = []
    internal var columns: [OTTableColumn] = []
    
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
    
    public func tableView(
        _ tableView: NSTableView,
        objectValueFor tableColumn: NSTableColumn?,
        row: Int
    ) -> Any? {
        // TODO: finish
        return "Test"
    }
    
    public func tableView(
        _ tableView: NSTableView,
        setObjectValue object: Any?,
        for tableColumn: NSTableColumn?,
        row: Int
    ) {
        // TODO: finish
    }
}
