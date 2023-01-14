//
//  UIImageView+RemoteImage.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit

extension UIImageView {
    func loadRemoteImage(path: String) -> RequestCancellable? {
        let activiyIndicator = getActivityIndicator()
        let activityIndicatorView = activiyIndicator.0
        let setActivityIndicator = activiyIndicator.1
        
        DispatchQueue.main.async {
            setActivityIndicator()
        }

        return NetworkManager.shared.requestResource(path: path) {
            [weak self, weak activityIndicatorView] result in
            switch result {
                case .success(let data):
                    self?.setImage(with: UIImage(data: data), activityIndicatorView)
                case .failure:
                    self?.setImage(with: UIImage(named: "anya"), activityIndicatorView)
            }
        }
    }
    
    @discardableResult
    func startLoader() -> UIActivityIndicatorView? {
        guard (subviews.compactMap { $0 as? UIActivityIndicatorView }).isEmpty else {
            return nil
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        
        addSubview(activityIndicator)
        let side: CGFloat = 50.0
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: side),
            activityIndicator.widthAnchor.constraint(equalToConstant: side)
        ])
        
        return activityIndicator
    }
    
    func stopLoader() {
        guard let activityIndicator = subviews.first(where: { ($0 as? UIActivityIndicatorView) != nil })
            as? UIActivityIndicatorView else { return }
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private func getActivityIndicator() -> (UIActivityIndicatorView, () -> Void) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return (activityIndicator, { [weak self, weak activityIndicator] in
            guard let self = self, let activityIndicator = activityIndicator else { return }
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            let side: CGFloat = 50.0
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                activityIndicator.heightAnchor.constraint(equalToConstant: side),
                activityIndicator.widthAnchor.constraint(equalToConstant: side)
            ])
        })
    }
    
    private func setImage(with image: UIImage?, _ activityIndicator: UIActivityIndicatorView? = nil) {
        DispatchQueue.main.async { [weak self, weak activityIndicator] in
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
            self?.image = image
        }
    }
}

//
// final class ImageService: RequestCancellable {
//    typealias ImageTask = (Result<Data, Error>) -> Void
//    // MARK: State
//    private var imageTask: ImageTask?
//    private(set) var networkTask: RequestCancellable?
//    private weak var activityIndicatorView: UIActivityIndicatorView?
//
//    // MARK: Initializers
//    init(_ activityIndicator: UIActivityIndicatorView, _ settings: @escaping ImageTask) {
//        self.imageTask = settings
//        self.activityIndicatorView = activityIndicator
//    }
//
//    // MARK: Methods
//    func cancel() {
//        networkTask?.cancel()
//        networkTask = nil
//        imageTask = nil
//        activityIndicatorView?.stopAnimating()
//        activityIndicatorView?.removeFromSuperview()
//    }
//
//    func resume(path: String) {
//        networkTask = NetworkManager.shared.requestResource(path: path) { [weak self] result in
//            self?.imageTask?(result)
//        }
//    }
// }
