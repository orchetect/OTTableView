import AppKit
import SwiftUI

public struct OTTable<RowValue>: NSViewRepresentable
where RowValue: Hashable,
      RowValue: Identifiable
{
    // MARK: Public properties
    
    @Binding public var contents: [RowValue]
    @Binding public var selection: Set<RowValue.ID>
    @State public var columns: [OTTableColumn]
    
    // MARK: Init
    
    public init(contents: Binding<Array<RowValue>>,
                selection: Binding<Set<RowValue.ID>>,
                columns: [OTTableColumn]) {
        self._contents = contents
        self._selection = selection
        self._columns = State(initialValue: columns)
    }
    
    // MARK: NSViewRepresentable overrides
    
    public typealias NSViewType = OTTableScrollView<RowValue>
    
    public func makeNSView(context: Context) -> NSViewType {
        let tv = OTTableView<RowValue>()
        
        // data source
        tv.dataSource = tv
        tv.delegate = tv
        
        // column setup
        for column in columns {
            let col = NSTableColumn()
            col.title = column.title
            tv.addTableColumn(col)
        }
        
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
        guard !viewModel.updatingFromCoordinator else { return }
        // mutex
        viewModel.updatingFromUpdateNSView = true
        defer { viewModel.updatingFromUpdateNSView = false }
        
        let tableView = nsView.tableView
        
        tableView.delegate = context.coordinator
        tableView.contents = contents
        tableView.selection = selection
        tableView.columns = columns
        tableView.reloadData()
        
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
            guard !parent.viewModel.updatingFromUpdateNSView else { return }
            // mutex
            parent.viewModel.updatingFromCoordinator = true
            defer { parent.viewModel.updatingFromCoordinator = false }
            
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
    
    @ObservedObject var viewModel: Self.ViewModel = .init()
    
    class ViewModel: ObservableObject {
        var updatingFromUpdateNSView: Bool = false
        var updatingFromCoordinator: Bool = false
    }
}

// MARK: - OTTableScrollView

public class OTTableScrollView<RowValue>: NSScrollView
where RowValue: Hashable,
      RowValue: Identifiable
{
    public typealias NSViewType = OTTableView<RowValue>
    
    public let tableView: OTTableView<RowValue>
    
    public init(tableView: OTTableView<RowValue>) {
        self.tableView = tableView
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - OTTableView

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

// MARK: - OTTableColumn

public struct OTTableColumn {
    public var title: String
    @Binding public var isVisible: Bool
    internal var _width: OTTableColumnWidth?
    
    public init(name: String, isVisible: Binding<Bool> = .constant(true)) {
        self.title = name
        self._isVisible = isVisible
    }
    
    // MARK: View Modifiers
    
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
    
    // MARK: Types
    
    internal enum OTTableColumnWidth {
        case exact(CGFloat)
        case limits(min: CGFloat?, ideal: CGFloat?, max: CGFloat?)
    }
}
