//
//  StarsScreenVMProtocol.swift
//  TodoList
//
//  Created by Renat Galiamov on 01.09.2025.
//

protocol StartScreenViewModelProtocol {
    var didLoadData: ((Result<Void, Error>) -> Void)? { get set }
    func loadData()
}
