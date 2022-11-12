//
//  OTTableScrollView.swift
//  OTTableView
//

import AppKit
import SwiftUI

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