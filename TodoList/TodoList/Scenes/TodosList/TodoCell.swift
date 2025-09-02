//
//  TodoListCell.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import UIKit

final class TodoCell: UITableViewCell {
    
    private enum UIConstants {
        static let nameLabelFont: UIFont = .systemFont(ofSize: 16, weight: .medium)
        static let descriptionLabelFont: UIFont = .systemFont(ofSize: 12)
        static let dateLabelFont: UIFont = .systemFont(ofSize: 12)
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 12
        static let checkmarkSize: CGFloat = 24
        static let stackViewSpacing: CGFloat = 6
        static let dividerHeight: CGFloat = 0.5
    }
    
    static let reuseIdentifier = "todoListCellReuseIdentifier"
    
    // MARK: - UI Elements
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.nameLabelFont
        label.textColor = .darkThemeWhite
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.descriptionLabelFont
        label.textColor = .darkThemeWhite
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.dateLabelFont
        label.textColor = .darkThemeGrey
        return label
    }()
    
    private lazy var bottomDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .todosBottomDivider
        return divider
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = UIConstants.stackViewSpacing
        return stack
    }()
    
    private lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with todoItem: TodoItem) {
        nameLabel.text = "Задача #\(todoItem.id)"
        nameLabel.strikeThrough(todoItem.isCompleted)
        descriptionLabel.text = todoItem.decription
        dateLabel.text = formatDate(Date())
        let checkmarkImage: UIImage = todoItem.isCompleted
        ? .checkedTodoItemButton
        : .uncheckedTodoItemButton
        checkmarkButton.setImage(checkmarkImage, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkmarkButton.isSelected = false
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.backgroundColor = .todosScreenBackground
        backgroundColor = .todosBottomPanelBackground
        
        [stackView, checkmarkButton, bottomDivider].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [nameLabel, descriptionLabel, dateLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        setupConstraints()
        setupContentPriorities()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                     constant: UIConstants.horizontalPadding),
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                 constant: UIConstants.verticalPadding),
            checkmarkButton.widthAnchor.constraint(equalToConstant: UIConstants.checkmarkSize),
            checkmarkButton.heightAnchor.constraint(equalToConstant: UIConstants.checkmarkSize),
            
            stackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor,
                                               constant: UIConstants.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -UIConstants.horizontalPadding),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: UIConstants.verticalPadding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -UIConstants.verticalPadding),
            
            bottomDivider.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomDivider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: UIConstants.dividerHeight)
        ])
    }
    
    private func setupContentPriorities() {
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    @objc private func checkmarkTapped() {
        checkmarkButton.isSelected.toggle()
    }
}
