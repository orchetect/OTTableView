# OTTableView

>  **Note**: This library is a work-in-progress and not suitable for production until first release is reached.

SwiftUI implementation of [`NSTableView`](https://developer.apple.com/documentation/appkit/nstableview) with features that SwiftUI's [`Table`](https://developer.apple.com/documentation/swiftui/table) lacks:

- Allows column reordering via drag-and-drop
- Allows columns to be hidden using a simple view modifier
- Provides introspection view modifiers to allow granular modifications to the NS objects if needed

Simple example:

```swift
var body: some View {
    @State var items: [TableItem] = [ ... ]
    @State var selection: Set<TableItem.ID> = []
    @State var isNameEditable: Bool = true
    @State var isKindColumnShown: Bool = true
    
    OTTable(items, selection: $selection) { item in
        OTTableColumn(title: "Name") {
            item.name
        } set: { itemID, newValue in
            guard let idx = items.first(where: { $0.id == itemID }) else { return }
            items[idx].name = newValue
        }
        .editable(isNameEditable)
        .width(150)

        OTTableColumn(title: "Comments") { 
            item.kind
        }
        .visible(isKindColumnShown)
        .width(min: 50, ideal: 100, max: 150)
        .introspect { tableColumn in
            tableColumn.resizingMask = [.userResizingMask]
        }
    }
    .introspect { tableView, scrollView in
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
