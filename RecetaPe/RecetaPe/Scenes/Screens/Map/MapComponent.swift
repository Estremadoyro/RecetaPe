//
//  MapComponent.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

#warning("As I'm currenly running out of time I'll be using some MVVM like arch.")
final class MapComponent {
    // MARK: State
    private var mapController: MapScreen

    // MARK: Initializers
    init(viewModel: MapViewModable) {
        self.mapController = MapScreen(viewModel: viewModel)
    }

    // MARK: Methods
    func getController() -> RPeNavigation {
        let navigation = RPeNavigation()
        navigation.setViewControllers([mapController], animated: false)
        return navigation
    }
}

