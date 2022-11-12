//
//  OTTable.swift
//  OTTableView
//

import AppKit
import SwiftUI

public struct OTTable<RowValue>: NSViewRepresentable
where RowValue: Hashable,
      RowValue: Identifiable
{
    // MARK: Public properties
    
    @Binding public var contents: [RowValue]
    @Binding public var selection: Set<RowValue.ID>
    @Binding public var columns: [OTTableColumn]
    
    // MARK: Init
    
    public init(contents: Binding<Array<RowValue>>,
                selection: Binding<Set<RowValue.ID>>,
                columns: [OTTableColumn]) {
        self._contents = contents
        self._selection = selection
        self._columns = .constant(columns)
    }
    
    // MARK: NSViewRepresentable overrides
    
    public typealias NSViewType = OTTableScrollView<RowValue>
    
    public func makeNSView(context: Context) -> NSViewType {
        let tv = OTTableView<RowValue>()
        
        // data source
        tv.dataSource = tv
        tv.delegate = tv
        
        // column setup
        for idx in columns.indices {
            let column = columns[idx]
            let col = NSTableColumn()
            col.title = column.title
            col.identifier = .init("\(idx)")
            
            switch column.width {
            case let .fixed(width):
                col.width = width
                col.resizingMask = []
            case let .limits(min: minW, ideal: idealW, max: maxW):
                if let minW { col.minWidth = minW }
                if let maxW { col.maxWidth = maxW }
                if let idealW { col.width = idealW }
                col.resizingMask = [.userResizingMask, .autoresizingMask]
            case .default:
                break
            }
            col.isHidden = !column.isVisible
            
            tv.addTableColumn(col)
        }
        
        // bahavior
        tv.allowsMultipleSelection = true
        
        // layout
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        // scrollview
        let sv = OTTableScrollView<RowValue>(tableView: tv)
        sv.documentView = tv
        sv.hasVerticalScroller = true
        
        return sv
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        // mutex
        guard !updateStatus.updatingFromCoordinator else { return }
        // mutex
        updateStatus.updatingFromUpdateNSView = true
        defer { updateStatus.updatingFromUpdateNSView = false }
        
        let tableView = nsView.tableView
        
        tableView.delegate = context.coordinator
        tableView.contents = contents
        tableView.selection = selection
        tableView.columns = columns
        tableView.reloadData()
        
        // update column visibility
        tableView.tableColumns.forEach { tableCol in
            guard let foundIdx = columns.indices.first(where: { idx in
                tableCol.identifier == .init("\(idx)")
            }) else { return }
            tableCol.isHidden = !columns[foundIdx].isVisible
        }
        
        // restore selection from state
        DispatchQueue.main.async {
            tableView.selectRowIndexes(contents.indices(for: selection), byExtendingSelection: false)
        }
    }
    
    // MARK: Helpers
    
    public func updateSelection(from indices: IndexSet) {
        let indices = contents.idsForIndices(indices)
        selection = indices
    }
    
    // MARK: Coordinator
    
    public class Coordinator<RowValue>: NSObject, NSTableViewDelegate
    where RowValue: Hashable,
          RowValue: Identifiable
    {
        var parent: OTTable
        
        init(_ parent: OTTable) {
            self.parent = parent
        }
        
        public func tableViewSelectionDidChange(_ notification: Notification) {
            guard let tableView = notification.object as? OTTableView<RowValue> else { return }
            
            updateParentSelection(in: tableView)
        }
        
        public func updateParentSelection(in tableView: OTTableView<RowValue>) {
            // mutex
            guard !parent.updateStatus.updatingFromUpdateNSView else { return }
            // mutex
            parent.updateStatus.updatingFromCoordinator = true
            defer { parent.updateStatus.updatingFromCoordinator = false }
            
            guard !parent.contents.isEmpty else { return }
            
            let selectedIndices = tableView.selectedRowIndexes
            
            // early return
            if selectedIndices.isEmpty {
                parent.updateSelection(from: .init())
            } else {
                parent.updateSelection(from: selectedIndices)
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator<RowValue> {
        Coordinator(self)
    }
    
    // MARK: Update Status
    
    @ObservedObject var updateStatus: Self.UpdateStatus = .init()
    
    class UpdateStatus: ObservableObject {
        var updatingFromUpdateNSView: Bool = false
        var updatingFromCoordinator: Bool = false
    }
}