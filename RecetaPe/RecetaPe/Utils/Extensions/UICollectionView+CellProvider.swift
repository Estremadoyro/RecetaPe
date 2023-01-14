//
//  UICollectionView+CellProvider.swift
//  RecetaPe
//
//  Created by Leonardo  on 9/01/23.
//

import UIKit

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return { (collectionView, indexPath, item) in
            collectionView.dequeueConfiguredReusableCell(using: self,
                                                         for: indexPath,
                                                         item: item)
        }
    }
}
