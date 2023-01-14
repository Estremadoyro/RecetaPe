//
//  RPeCollectionDelegate.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

final class RPeCollectionDelegate: NSObject, UICollectionViewDelegate  {
    // MARK: State
    weak var delegate: RPeTapEventsSendable?

    // MARK: Initializers
    override init() {}

    // MARK: Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(collectionView, didSelectItemAt: indexPath)
        Logger<Self>.log("did tap cell")
    }
}
