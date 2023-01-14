//
//  SceneContracts.swift
//  RecetaPe
//
//  Created by Leonardo  on 8/01/23.
//

import UIKit

protocol Screen: UIViewController {
    associatedtype Presenter
    
    init(presenter: Presenter)
}
