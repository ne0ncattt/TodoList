//
//  ViewController.swift
//  TodoList
//
//  Created by Renat Galiamov on 31.08.2025.
//

import UIKit


final class TodosViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.register(TodoCell.self,
                       forCellReuseIdentifier: TodoCell.reuseIdentifier)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var bottomPanel: TodosBootomView = {
        let view = TodosBootomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let viewModel: TodosViewModelProtocol
    
    init(viewModel: TodosViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .todosScreenBackground
        setupSearchBar()
        setupUIComponents()
        bindViewModel()
        viewModel.loadModel()
    }
    
    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    private func bindViewModel() {
        viewModel.didLoadNewModel = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.bottomPanel.configure(with: self.viewModel.itemsToDisplay.count)
            }
        }
    }
    
    private func setupUIComponents() {
        
        title = "Задачи"
        
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .themeYellow
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.layer.shadowColor = UIColor.clear.cgColor
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        view.addSubview(bottomPanel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            bottomPanel.heightAnchor.constraint(equalToConstant: TodosBootomView.UIConastants.panelHeight),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        view.bringSubviewToFront(bottomPanel)
        
        bottomPanel.didPressCreate = { [weak self] in
            self?.viewModel.createItem()
        }
    }
}

extension TodosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.reuseIdentifier,
                                                       for: indexPath) as? TodoCell
        else { return UITableViewCell() }
        cell.configure(with: viewModel.itemsToDisplay[indexPath.row])
        cell.didPressCheckmark = { [weak self] in
            self?.viewModel.toggleTodoItemCompleteion(at: indexPath.row)
        }
        return cell
    }
    
    
}

extension TodosViewController {
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSIndexPath) {
            self.preview(for: indexPath)
        } actionProvider: { _ in
            self.menu(for: indexPath)
        }
    }
    
    private func menu(for indexPath: IndexPath) -> UIMenu {
        let edit = UIAction(
            title: "Редактировать",
            image: UIImage(systemName: "square.and.pencil")) { _ in
                self.viewModel.editItem(at: indexPath.row)
            }
        
        let share = UIAction(
            title: "Поделиться",
            image: UIImage(systemName: "square.and.arrow.up")) { _ in
                
            }

        let delete = UIAction(
            title: "Удалить",
            image: UIImage(systemName: "trash"),
            attributes: .destructive) { _ in
                self.viewModel.deleteItem(at: indexPath.row)
            }
        return UIMenu(title: "", children: [edit, share, delete,])
    }
    
    func preview(for indexPath: IndexPath) -> UIViewController? {
        // превью будет отличаться от макета, но, думаю, в тестовом задании это будет писать излишне
        return nil
    }
}

extension TodosViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filterQuery = ""
    }
}

extension TodosViewController {

}
