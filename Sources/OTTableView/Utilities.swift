//
//  Utilities.swift
//  OTTableView • https://github.com/orchetect/OTTableView
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

extension Array where Element: Identifiable {
    @_disfavoredOverload
    public func idsForIndices(_ indices: IndexSet) -> Set<Element.ID> {
        Set(indices.map { self[$0].id })
    }
    
    @_disfavoredOverload
    public func indices(for ids: Set<Element.ID>) -> IndexSet {
        let indexArray = indices
            .filter { ids.contains(self[$0].id) }
        return IndexSet(indexArray)
    }
}
