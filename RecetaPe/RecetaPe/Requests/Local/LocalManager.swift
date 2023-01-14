//
//  LocalManager.swift
//  RecetaPe
//
//  Created by Leonardo  on 11/01/23.
//

import Foundation

protocol LocalRequestable {
    func find()
    func insert()
    func getAll()
}

final class LocalManager: LocalRequestable {
    // MARK: State

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func find() {}

    func insert() {}

    func getAll() {}
}
