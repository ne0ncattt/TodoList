//
//  StartScreenVC.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

import UIKit

final class StartScreenViewController: UIViewController {
    
    private var viewModel: StartScreenViewModelProtocol
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "questionmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkThemeWhite
        return imageView
    }()
    
    private lazy var loadingIndicator:  UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        indicator.color = .darkThemeWhite
        return indicator
    }()
    
    
    init(viewModel: StartScreenViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadingIndicator.startAnimating()
        viewModel.loadData()
    }

    private func setupView() {
        [logoImageView, loadingIndicator].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(logoImageView)
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
        ])
    }
    
    private func bindViewModel() {
        viewModel.didLoadData = { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showErrorAlert(error)
            default:
                break
            }
            
        }
    }
    
    private func showErrorAlert(_ error : Error) {
        let alert = UIAlertController(title: "Ошибка :(",
                                      message: "Ошибка: \(error.localizedDescription)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить загрузка", style: .default, handler: { _ in
            self.viewModel.loadData()
        }))
        present(alert, animated: true)
    }
}
