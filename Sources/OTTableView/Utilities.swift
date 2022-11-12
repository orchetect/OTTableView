//
//  OTTableColumn.swift
//  OTTableView
//

import SwiftUI

extension Array where Element: Identifiable {
    @_disfavoredOverload
    public func idsForIndices(_ indices: IndexSet) -> Set<Element.ID> {
        Set(indices.map { self[$0].id })
    }
    
    @_disfavoredOverload
    public func indices(for ids: Set<Element.ID>) -> IndexSet {
        let indexArray = indices.filter { index in
            ids.contains(self[index].id)
        }
        return IndexSet(indexArray)
    }
}
