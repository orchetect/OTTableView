//
//  Utilities.swift
//  Demo
//
//  Created by Steffan Andrews on 2022-11-11.
//

import Foundation
import SwiftUI

extension Array where Element: Identifiable {
    func idsForIndices(_ indices: IndexSet) -> Set<Element.ID> {
        Set(indices.map { self[$0].id })
    }
    
    func indices(for ids: Set<Element.ID>) -> IndexSet {
        let indexArray = indices.filter { index in
            ids.contains(self[index].id)
        }
        return IndexSet(indexArray)
    }
}
