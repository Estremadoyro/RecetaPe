//
//  ImageService.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

final class ImageService {
    // MARK: State

    // MARK: Initializers
    init() {}

    // MARK: Methods
    func image(path: String, completion: @escaping (UIImage?) -> Void) -> RequestCancellable? {
        return NetworkManager.shared.requestResource(path: path) { result in
            var image: UIImage?

            defer {
                DispatchQueue.main.async {
                    completion(image)
                }
            }

            switch result {
                case .success(let data): image = UIImage(data: data)
                case .failure: image = UIImage(named: "anya")
            }
        }
    }
}
