//
//  ContentView.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTTableView

struct ContentView: View {
    @State var tableContents: [TableItem] = .mockItems()
    @State var selection: Set<TableItem.ID> = []
    @State var isKindColumnShown: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button("Add") { addItem() }
                Button("Insert") { insertItem() }
                Button("Delete") { removeSelected() }.disabled(selection.isEmpty)
                Spacer()
                Toggle("Show Kind", isOn: $isKindColumnShown)
            }
            
            OTTable(
                scrollAxes: [.vertical],
                showsScrollIndicators: false,
                contents: $tableContents,
                selection: $selection,
                columns: [
                    OTTableColumn(title: "Name") {
                        $0.name
                    } set: { row, newValue in
                        guard let newValue = newValue as? String,
                              tableContents.indices.contains(row)
                        else { return }
                        tableContents[row].name = newValue
                    }
                    .width(150),
                    
                    OTTableColumn(title: "Kind (read-only)") {
                        $0.kind
                    }
                    .visible(isKindColumnShown)
                    .width(min: 50, ideal: 100, max: 150),
                    
                    OTTableColumn(title: "Comments") {
                        $0.comments
                    } set: { row, newValue in
                        guard let newValue = newValue as? String,
                              tableContents.indices.contains(row)
                        else { return }
                        tableContents[row].comments = newValue
                    }
                    .width(min: 150, ideal: 200, max: 1000)
                    .introspect { tableColumn in
                        tableColumn.resizingMask = [.userResizingMask]
                    }
                ]
            )
            .introspect { tableView, scrollView in
                tableView.allowsExpansionToolTips = true
                tableView.style = .fullWidth
                scrollView.usesPredominantAxisScrolling = false
            }
            .onDeleteCommand {
                removeSelected()
            }
            
            HStack {
                let selItems = tableContents.indices(for: selection)
                if !selItems.isEmpty {
                    Text(selItems.map { "\(tableContents[$0].name)" }.joined(separator: ", "))
                } else {
                    Text("No selection.")
                }
            }
        }
        .padding()
    }
    
    func addItem(_ item: TableItem = .newItem()) {
        tableContents.append(item)
    }
    
    func insertItem(_ item: TableItem = .newItem()) {
        let defaultIdx = tableContents.endIndex
        let idx = selection.isEmpty
            ? defaultIdx
            : tableContents.firstIndex(where: { selection.contains($0.id) })
                ?? defaultIdx
        
        tableContents.insert(item, at: idx)
    }
    
    func removeSelected() {
        tableContents.removeAll(where: { selection.contains($0.id) })
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
