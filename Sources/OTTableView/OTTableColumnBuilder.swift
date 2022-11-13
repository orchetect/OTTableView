//
//  OTTableColumnBuilder.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// ResultBuilder tutorial: https://developer.apple.com/wwdc21/10253
@resultBuilder
public enum OTTableColumnBuilder<RowValue>
where RowValue: Hashable, RowValue: Identifiable
{
    public static func buildBlock(_ components: OTTableColumn<RowValue>...) -> [OTTableColumn<RowValue>] {
        components
    }
    
    public static func buildEither(first component: [OTTableColumn<RowValue>]) -> [OTTableColumn<RowValue>] {
        component
    }
    
    public static func buildEither(second component: [OTTableColumn<RowValue>]) -> [OTTableColumn<RowValue>] {
        component
    }
    
    public static func buildOptional(_ component: [OTTableColumn<RowValue>]?) -> [OTTableColumn<RowValue>] {
        component ?? []
    }
    
    public static func buildBlock(_ components: [OTTableColumn<RowValue>]...) -> [OTTableColumn<RowValue>] {
        // TODO: this crashes - not sure why
        components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: OTTableColumn<RowValue>) -> [OTTableColumn<RowValue>] {
        [expression]
    }
    
    public static func buildExpression(_ expression: Void) -> [OTTableColumn<RowValue>] {
        [OTTableColumn]()
    }
}
