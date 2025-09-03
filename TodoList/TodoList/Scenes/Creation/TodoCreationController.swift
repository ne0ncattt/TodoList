//
//  TodoCreationController.swift
//  TodoList
//
//  Created by Renat Galiamov on 03.09.2025.
//

import UIKit

final class TodoCreationController : UIViewController {
    
    enum Mode {
        case creation
        case editing
    }
    
    private var mode: Mode = .creation
    private var itemToEdit: TodoItem?
    
    enum UIConstants {
        static let horizontalOffset: CGFloat = 20
        static let verticalOffset: CGFloat = 8
    }
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textField.textColor = .darkThemeWhite
        textField.tintColor = .themeYellow
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textView.textColor = .darkThemeWhite
        textView.tintColor = .themeYellow
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkThemeGrey
        return label
    }()
    
    private var viewModel: TodoCreationViewModelProtocol
    
    init(viewModel: TodoCreationViewModelProtocol,
         mode: Mode = .creation,
         itemToEdit: TodoItem? = nil) {
        self.viewModel = viewModel
        self.mode = mode
        self.itemToEdit = itemToEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .todosScreenBackground
        dateLabel.text = formatDate(Date())
        setupUI()
        if mode == .editing, let itemToEdit {
            titleTextField.text = itemToEdit.title
            descriptionTextView.text = itemToEdit.decription
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        [
            titleTextField,
            dateLabel,
            descriptionTextView,
        ]
        .forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.verticalOffset),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.horizontalOffset - 1),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.horizontalOffset),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: UIConstants.verticalOffset),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.horizontalOffset),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: UIConstants.verticalOffset),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.horizontalOffset - 4),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.horizontalOffset),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

extension TodoCreationController {
    private func validateInput() {
        guard let title = titleTextField.text,
              let description = descriptionTextView.text,
              !title.isEmpty && !description.isEmpty
        else {
            removeDoneButton()
            return
        }
        addDoneButton()
    }

    private func addDoneButton() {
        let doneButton = UIBarButtonItem(title: "Готово",
                                         image: nil,
                                         target: self,
                                         action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    private func removeDoneButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc
    private func addButtonPressed() {
        let title = titleTextField.text ?? "Unknown"
        let description = descriptionTextView.text ?? "Unknown"
        switch mode {
        case .creation:
            createItem(with: title, description: description)
        case .editing:
            updateItem(with: title, description: description)
        }
    }
    
    private func createItem(with title: String, description: String) {
        let itemToCreate = TodoItem(id: -1,
                                   decription: description,
                                   isCompleted: false,
                                   userId: 0,
                                   title: title,
                                   date: Date())
        viewModel.createItem(itemToCreate)
    }
    
    private func updateItem(with title: String, description: String) {
        guard let itemToEdit else { return }
        let updatedItem = TodoItem(id: itemToEdit.id,
                                   decription: description,
                                   isCompleted: itemToEdit.isCompleted,
                                   userId: itemToEdit.userId,
                                   title: title,
                                   date: itemToEdit.date)
        viewModel.updateItem(updatedItem)
    }
}

extension TodoCreationController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        validateInput()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
        return true
    }
    
}

extension TodoCreationController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateInput()
    }
}
