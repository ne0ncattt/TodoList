//
//  ViewController.swift
//  TodoList
//
//  Created by Renat Galiamov on 31.08.2025.
//

import UIKit

final class TodosListVC: UIViewController {
    
    private enum UIConastants {
        
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = UITableView.automaticDimension
        table.register(TodoListCell.self,
                       forCellReuseIdentifier: TodoListCell.reuseIdentifier)
        table.separatorStyle = .none
        table.backgroundColor = .todosScreenBackground
        return table
    }()
    
    private lazy var bottomPanel: BootomPanelView = {
        let view = BootomPanelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .todosScreenBackground
        setupUIComponents()
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
            bottomPanel.heightAnchor.constraint(equalToConstant: BootomPanelView.UIConastants.panelHeight),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
        
        view.bringSubviewToFront(bottomPanel)
    }
    
    private lazy var mockData: [TodoItem] = {
        let mockStrings = ["""
                          Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
                          """,
                          """
                          A wonderful serenity has taken possession of my entire soul,
                          like these sweet mornings of spring which I enjoy with my whole heart. 
                          """,
                          """
                          Lorem ipsum dolor sit amet consectetur adipiscing elit. 
                          Consectetur adipiscing elit quisque faucibus ex sapien vitae.
                          Ex sapien vitae pellentesque sem placerat in id. 
                          Placerat in id cursus mi pretium tellus duis.
                          Pretium tellus duis convallis tempus leo eu aenean.
                          """,
                          """
                          Lorem Ipsum is simply dummy text of the printing and typesetting industry. 
                          """,
        ]
        var array = [TodoItem]()
        for index in 0...200 {
            array.append(TodoItem(id: Int.random(in: 1...200000),
                                  todo: mockStrings.randomElement() ?? "",
                                  completed: Bool.random(),
                                  userId: 0))
        }
        return array
    }()
}



extension TodosListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoListCell.reuseIdentifier,
                                                       for: indexPath) as? TodoListCell
        else { return UITableViewCell() }
        cell.configure(with: mockData[indexPath.row])
        return cell
    }
}

