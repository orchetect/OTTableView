# OTTableView

SwiftUI implementation of [`NSTableView`](https://developer.apple.com/documentation/appkit/nstableview) with features that SwiftUI's [`Table`](https://developer.apple.com/documentation/swiftui/table) lacks:

- Allows column reordering via drag-and-drop
- Allows columns to be hidden using a simple view modifier

Simple example:

```swift
var body: some View {
    @State var contents: [TableItem] = [ ... ]
    @State var selection: Set<TableItem.ID> = []
    @State var isKindColumnShown: Bool = true
    
    OTTable(
        contents: $contents,
        selection: $selection,
        columns: [
            OTTableColumn(title: "Name") { 
                $0.name
            } set: { row, newValue in
                tableContents[row].name = newValue as? String ?? ""
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
                tableContents[row].comments = newValue as? String ?? ""
            }
            .width(min: 150, ideal: 200, max: 1000)
        ]
    )
}
```

## Getting Started

1. Add the package to your application as a dependency using Swift Package Manager
2. `import OTTableView`
3. Profit

## Roadmap

- [ ] Allow for single-selection or no-selection modes (in addition to the current multi-select mode)
- [ ] Allow programmatic read/write of `OTTable` column order (via SwiftUI Binding)
- [ ] Allow cell editable toggle by way of new `.editable(Bool)` modifier on `OTTableColumn`. (For now, any `OTTableColumn` with a setter closure is editable and any without the closure (nil) are read-only.)
- [ ] Allow table sorting (may require some custom abstractions)
- [ ] Add ergonomics, ie: contextual row selection after appending, inserting, or deleting rows
- [ ] Performance optimizations
