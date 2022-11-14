# OTTableView

![Platforms - macOS 10.15+](https://img.shields.io/badge/platforms-macOS%2010.15+-lightgrey.svg?style=flat) ![Swift 5.5-5.7](https://img.shields.io/badge/Swift-5.5–5.7-orange.svg?style=flat) [![Xcode 14](https://img.shields.io/badge/Xcode-14-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Pseudo-declarative [`NSTableView`](https://developer.apple.com/documentation/appkit/nstableview) wrapper for SwiftUI.

> **Note**: This library is a work-in-progress and may not be suitable for production until first release is reached.

## Motivation

For data-driven apps where classic macOS UI ergonomics are expected, `NSTableView` is still relevant.

OTTableView brings `NSTableView` into the declarative SwiftUI space, and also brings some features that SwiftUI's Table lacks:

- Allows column reordering via drag-and-drop
- Allows columns to be hidden using a simple view modifier
- Provides an `.introspect { }` view modifier to allow granular modifications to the NS objects if needed

## Basic Usage

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
3. See the [Demo](Demo) project for example usage.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](LICENSE) for details.

## Sponsoring

If you enjoy using OSCKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Roadmap & Contributions

Planned and in-progress features can be found in [Issues](https://github.com/orchetect/OTTableView/issues). Any help is welcome and appreciated.
