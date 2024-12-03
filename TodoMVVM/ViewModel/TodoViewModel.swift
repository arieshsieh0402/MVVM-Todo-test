//
//  TodoViewModel.swift
//  TodoMVVM
//
//  Created by aries.hsieh on 2024/12/3.
//

import Foundation
import Combine

class TodoViewModel: ObservableObject {
    // 待辦事項清單
    @Published private(set) var todos: [Todo] = []

    // 新增待辦事項
    func addTodo(title: String) {
        let newTodo = Todo(title: title)
        todos.append(newTodo)
    }

    // 切換完成狀態
    func toggleTodoCompletion(at index: Int) {
        guard todos.indices.contains(index) else { return }
        todos[index].isCompleted.toggle()
    }
}
