# OTTableView

SwiftUI implementation of NSTableView with more flexibility than SwiftUI's `Table`:

- Allows column reordering via drag-and-drop
- Allows columns to be hidden using a simple view modifier

## Getting Started

1. Add the package to your application.
2. `import OTTableView`
3. Profit

## Roadmap

- Allow programmatic read/write of `OTTable` column order (via SwiftUI Binding)
- Allow cell editable toggle by way of new `.editable(Bool)` modifier on `OTTableColumn`. (For now, any `OTTableColumn` with a setter closure is editable and any without the closure (nil) are read-only.)
- Allow table sorting (may require some custom abstractions)
