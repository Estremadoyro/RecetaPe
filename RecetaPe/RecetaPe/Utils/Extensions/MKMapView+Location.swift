//
//  MKMapView+Location.swift
//  RecetaPe
//
//  Created by Leonardo  on 13/01/23.
//

import MapKit

extension MKMapView {
    func centerToLocation(_ location2D: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 120000) {
        let location = CLLocation(latitude: location2D.latitude, longitude: location2D.longitude)
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(coordinateRegion, animated: true)
    }
}
