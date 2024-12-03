//
//  Todo.swift
//  TodoMVVM
//
//  Created by aries.hsieh on 2024/12/3.
//

import Foundation
import Combine

struct Todo: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool

    init(title: String, isCompleted: Bool = false) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
    }
}
