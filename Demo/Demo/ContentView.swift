//
//  ContentView.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OTTableView

struct ContentView: View {
    @State var items: [TableItem] = .mockItems()
    @State var selection: Set<TableItem.ID> = []
    @State var isKindColumnShown: Bool = true
    @State var isCommentsEditable: Bool = true
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button("Add") { addItem() }
                Button("Insert") { insertItem() }
                Button("Delete") { removeSelected() }.disabled(selection.isEmpty)
                Spacer()
                Toggle("Show Kind", isOn: $isKindColumnShown)
                Toggle("Comments Editable", isOn: $isCommentsEditable)
            }
            
            OTTable(items, selection: $selection) {
                OTTableColumn(title: "Name", id: "Name") {
                    $0.name
                } set: { row, newValue in
                    guard let newValue = newValue as? String,
                          items.indices.contains(row)
                    else { return }
                    items[row].name = newValue
                }
                .width(150)
                    
                OTTableColumn(title: "Kind (read-only)", id: "Kind") {
                    $0.kind
                }
                .visible(isKindColumnShown)
                .width(min: 50, ideal: 100, max: 150)
                    
                OTTableColumn(title: "Comments", id: "Comments") {
                    $0.comments
                } set: { row, newValue in
                    guard let newValue = newValue as? String,
                          items.indices.contains(row)
                    else { return }
                    items[row].comments = newValue
                }
                .width(min: 150, ideal: 200, max: 1000)
                .editable(isCommentsEditable)
                .introspect { tableColumn in
                    tableColumn.resizingMask = [.userResizingMask]
                }
            }
            .introspect { tableView, scrollView in
                tableView.allowsExpansionToolTips = true
                tableView.style = .fullWidth
                scrollView.usesPredominantAxisScrolling = false
            }
            .onDeleteCommand {
                removeSelected()
            }
            
            HStack {
                let selItems = items.indices(for: selection)
                if !selItems.isEmpty {
                    Text(selItems.map { "\(items[$0].name)" }.joined(separator: ", "))
                } else {
                    Text("No selection.")
                }
            }
        }
        .padding()
    }
    
    func addItem(_ item: TableItem = .newItem()) {
        items.append(item)
    }
    
    func insertItem(_ item: TableItem = .newItem()) {
        let defaultIdx = items.endIndex
        let idx = selection.isEmpty
            ? defaultIdx
            : items.firstIndex(where: { selection.contains($0.id) })
                ?? defaultIdx
        
        items.insert(item, at: idx)
    }
    
    func removeSelected() {
        items.removeAll(where: { selection.contains($0.id) })
    }
}

// MARK: - Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
