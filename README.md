# OTTableView

SwiftUI implementation of [`NSTableView`](https://developer.apple.com/documentation/appkit/nstableview) with features that SwiftUI's [`Table`](https://developer.apple.com/documentation/swiftui/table) lacks:

- Allows column reordering via drag-and-drop
- Allows columns to be hidden using a simple view modifier
- Provides introspection view modifiers to allow granular modifications to the NS objects if needed

Simple example:

```swift
var body: some View {
    @State var contents: [TableItem] = [ ... ]
    @State var selection: Set<TableItem.ID> = []
    @State var isKindColumnShown: Bool = true
    @State var isCommentsEditable: Bool = true
    
    OTTable(contents: $contents, selection: $selection) {
        OTTableColumn(title: "Name") {
            $0.name
        } set: { row, newValue in
            contents[row].name = newValue
        }
        .width(150)

        OTTableColumn(title: "Kind (read-only)") { 
            $0.kind
        }
        .visible(isKindColumnShown)
        .width(min: 50, ideal: 100, max: 150)

        OTTableColumn(title: "Comments") { 
            $0.comments
        } set: { row, newValue in
            contents[row].comments = newValue
        }
        .width(min: 150, ideal: 200, max: 1000)
        .editable(isCommentsEditable)
        .introspect { tableColumn in
            tableColumn.resizingMask = [.userResizingMask]
        }
    }
    .introspect { tableView, scrollView in
        // make property modifications that do not have dedicated view modifiers
        tableView.allowsExpansionToolTips = true
        scrollView.usesPredominantAxisScrolling = false
    }
}
```

## Getting Started

1. Add the package to your application as a dependency using Swift Package Manager
2. `import OTTableView`
3. Profit

## Roadmap

- [ ] View Modifiers
  - [x] `OTTable`: scroll view axes (SwiftUI `Axis.Set`)
- [ ] Allow for single-selection or no-selection modes (in addition to the current multi-select mode)
- [ ] Allow programmatic read/write of `OTTable` column order (via SwiftUI Binding of `[OTTableColumnID]`)
- [x] Allow cell editable toggle by way of new `.editable(Bool)` modifier on `OTTableColumn`. (For now, any `OTTableColumn` with a setter closure is editable and any without the closure (nil) are read-only.)
- [ ] Allow table sorting (may require some custom abstractions)
- [ ] Add view modifier methods to take closures for certain useful `NSTableView` delegate method bodies, such as drag and drop
- [ ] Add ergonomics, ie: contextual row selection after appending, inserting, or deleting rows
- [x] Implement column result builder instead of `OTTableColumn` array
- [ ] Performance optimizations
