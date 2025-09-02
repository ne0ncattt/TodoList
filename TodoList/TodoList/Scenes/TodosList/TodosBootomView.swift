//
//  Untitled.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import UIKit

final class TodosBootomView: UIView {
    
    enum UIConastants {
        static let panelHeight: CGFloat = 83
        static let counterTextFont: UIFont = .systemFont(ofSize: 11)
        static let createButtonSize: CGSize = .init(width: 68, height: 44)
    }
    
    private lazy var panelTopDivider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .todosBottomDivider
        return divider
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIConastants.counterTextFont
        label.textColor = .darkThemeWhite
        label.text = "8 задач"
        return label
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 18,
                                                              weight: .regular,
                                                              scale: .large)
        let configuredSymbolImage = UIImage(systemName: "square.and.pencil",
                                            withConfiguration: symbolConfiguration)
        button.tintColor = .themeYellow
        button.setImage(configuredSymbolImage, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tasksCount: Int) {
        counterLabel.text = "\(tasksCount) задач"
    }
    
    private func configureUI() {
        backgroundColor = .todosBottomPanelBackground
        [
            panelTopDivider,
            counterLabel,
            createButton,
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        NSLayoutConstraint.activate([
            panelTopDivider.heightAnchor.constraint(equalToConstant: 0.5),
            panelTopDivider.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            panelTopDivider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            panelTopDivider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            counterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            counterLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            
            createButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            createButton.heightAnchor.constraint(equalToConstant: UIConastants.createButtonSize.height),
            createButton.widthAnchor.constraint(equalToConstant: UIConastants.createButtonSize.width),
        ])
    }
}
