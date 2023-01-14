//
//  MapScreen.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import UIKit
import RxSwift
import MapKit

final class MapScreen: UIViewController {
    // MARK: State
    /// # ViewModel
    private var viewModel: MapViewModable

    /// # NavBar
    private lazy var navBar = MapNavBar(self)

    private lazy var disposeBag = DisposeBag()

    /// # UI
    /// Map view
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .mutedStandard
        view.addSubview(map)
        return map
    }()

    // MARK: Initializers
    init(viewModel: MapViewModable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Life Cycle
extension MapScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureScreen()
    }
}

private extension MapScreen {
    func configureBindings() {
        viewModel.recipe
            .drive(onNext: { [weak self] (recipe) in
                guard let self = self else { return }
                self.navBar.configureTitle(with: recipe.location)
                self.mapView.centerToLocation(recipe.location.coordinate)
                self.mapView.addAnnotation(recipe.location)
            }).disposed(by: disposeBag)
    }

    func configureScreen() {
        view.backgroundColor = RPeColor.white
        layoutMap()
    }
}

extension MapScreen {
    func layoutMap() {
        let xInset: CGFloat = 0
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xInset),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xInset),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
