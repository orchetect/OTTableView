//
//  OTTable.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public struct OTTable<RowValue>: NSViewRepresentable
    where RowValue: Hashable, RowValue: Identifiable
{
    // MARK: Public properties
    
    public var scrollAxes: Axis.Set
    public var showsScrollIndicators: Bool
    @Binding public var contents: [RowValue]
    @Binding public var selection: Set<RowValue.ID>
    @Binding public var columns: [OTTableColumn<RowValue>]
    
    // MARK: Introspection
    
    public typealias IntrospectBlock = (
        _ tableView: OTTableView<RowValue>,
        _ scrollView: OTTableScrollView<RowValue>
    ) -> Void
    
    internal var introspectBlocks: [IntrospectBlock] = []
    
    // MARK: Init
    
    @_disfavoredOverload
    public init(
        scrollAxes: Axis.Set = [.horizontal, .vertical],
        showsScrollIndicators: Bool = true,
        contents: Binding<[RowValue]>,
        selection: Binding<Set<RowValue.ID>>,
        columns: [OTTableColumn<RowValue>]
    ) {
        self.scrollAxes = scrollAxes
        self.showsScrollIndicators = showsScrollIndicators
        _contents = contents
        _selection = selection
        _columns = .constant(columns)
    }
    
    public init(
        scrollAxes: Axis.Set = [.horizontal, .vertical],
        showsScrollIndicators: Bool = true,
        contents: Binding<[RowValue]>,
        selection: Binding<Set<RowValue.ID>>,
        @OTTableColumnBuilder<RowValue> _ builder: () -> [OTTableColumn<RowValue>]
    ) {
        self.init(
            scrollAxes: scrollAxes,
            showsScrollIndicators: showsScrollIndicators,
            contents: contents,
            selection: selection,
            columns: builder()
        )
    }
    
    // MARK: NSViewRepresentable overrides
    
    public typealias NSViewType = OTTableScrollView<RowValue>
    
    public func makeNSView(context: Context) -> NSViewType {
        let tv = buildTableView()
        let sv = buildScrollView(tableView: tv)
        return sv
    }
    
    private func buildTableView() -> OTTableView<RowValue> {
        let tv = OTTableView<RowValue>()
        
        // data source
        tv.dataSource = tv
        tv.delegate = tv
        tv.axes = scrollAxes
        
        // column setup
        for idx in columns.indices {
            let column = columns[idx]
            let col = NSTableColumn()
            col.title = column.title
            col.identifier = column.id.id
            
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
            col.isEditable = column.setValue != nil
            
            // introspection blocks
            for block in column.introspectBlocks {
                block(col)
            }
            tv.addTableColumn(col)
        }
        
        // bahavior
        tv.allowsMultipleSelection = true
        
        // layout
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        // style
        tv.usesAlternatingRowBackgroundColors = true
        
        return tv
    }
    
    private func buildScrollView(
        tableView: OTTableView<RowValue>
    ) -> OTTableScrollView<RowValue> {
        let sv = OTTableScrollView<RowValue>(tableView: tableView)
        
        // content and geometry
        sv.translatesAutoresizingMaskIntoConstraints = false // has no effect?
        sv.documentView = tableView
        
        sv.hasVerticalScroller = scrollAxes.contains(.vertical)
        sv.hasHorizontalScroller = scrollAxes.contains(.horizontal)
        
        // prevent glitchy behavior when axes are constrained
        sv.verticalScrollElasticity = scrollAxes.contains(.vertical) ? .automatic : .none
        sv.horizontalScrollElasticity = scrollAxes.contains(.horizontal) ? .automatic : .none
        
        // introspection blocks
        for block in introspectBlocks {
            block(tableView, sv)
        }
        
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
            guard let foundIdx = columns.firstIndex(matching: tableCol) else { return }
            tableCol.isHidden = !columns[foundIdx].isVisible
            tableCol.isEditable = columns[foundIdx].isEditable
        }
        
        // restore selection from state
        DispatchQueue.main.async {
            tableView.selectRowIndexes(
                contents.indices(for: selection),
                byExtendingSelection: false
            )
        }
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
    
    // MARK: Helpers
    
    public func updateSelection(from indices: IndexSet) {
        let indices = contents.idsForIndices(indices)
        selection = indices
    }
}

// MARK: View Modifiers

extension OTTable {
    /// A generic introspection block that allows direct access to the table view and scroll view objects.
    public func introspect(
        _ block: @escaping IntrospectBlock
    ) -> Self {
        var copy = self
        copy.introspectBlocks.append(block)
        return copy
    }
}
