//
//  OTTableScrollView.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import AppKit
import SwiftUI

public class OTTableScrollView<RowValue>: NSScrollView
    where RowValue: Hashable, RowValue: Identifiable
{
    public let tableView: OTTableView<RowValue>
    
    // MARK: Init
    
    public init(tableView: OTTableView<RowValue>) {
        self.tableView = tableView
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
