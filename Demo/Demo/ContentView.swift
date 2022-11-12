//
//  ContentView.swift
//  Demo
//
//  Created by Steffan Andrews on 2022-11-11.
//

import SwiftUI
import OTTableView

struct ContentView: View {
    @State var tableContents: [TableItem] = .mockItems()
    @State var selection: Set<TableItem.ID> = []
    
    var body: some View {
        VStack {
            HStack {
                Button("Add") {
                    addItem()
                }
                
                Button("Insert") {
                    insertItem()
                }
                
                Button("Delete") {
                    removeSelected()
                }.disabled(selection.isEmpty)
            }
            
            OTTable(
                contents: $tableContents,
                selection: $selection,
                columns: [
                    .init(name: "Name").width(150),
                    .init(name: "Comments").width(min: 150, ideal: 200, max: 1000)
                ]
            )
        }
        .padding()
    }
    
    func addItem(_ item: TableItem = .init(value: "New Item")) {
        tableContents.append(item)
    }
    
    func insertItem(_ item: TableItem = .init(value: "New Item")) {
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
