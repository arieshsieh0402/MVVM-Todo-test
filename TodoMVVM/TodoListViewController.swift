//
//  TodoListViewController.swift
//  TodoMVVM
//
//  Created by aries.hsieh on 2024/12/3.
//

import UIKit
import Combine

class TodoListViewController: UIViewController {
    private var viewModel = TodoViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "待辦清單"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")

        addButton.setTitle("新增", for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(addButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupActions() {
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.$todos
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc private func addTodo() {
        let alertController = UIAlertController(title: "新增待辦事項", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "輸入事項"
        }
        let addAction = UIAlertAction(title: "新增", style: .default) { _ in
            if let title = alertController.textFields?.first?.text, !title.isEmpty {
                self.viewModel.addTodo(title: title)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = viewModel.todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.accessoryType = todo.isCompleted ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTodoCompletion(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
