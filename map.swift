//
//  Map.swift
//  HealthAPP
//
//  Created by Ved Borade on 3/4/24.
//

import SwiftUI
import MapKit

struct EmergencyMedicalCenter: Identifiable {
    var id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D

    var annotation: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = coordinate
        return annotation
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var emergencyMedicalCenters: [EmergencyMedicalCenter]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(emergencyMedicalCenters.map { $0.annotation })

        if let selectedCenter = emergencyMedicalCenters.first {
            uiView.selectAnnotation(selectedCenter.annotation, animated: true)
        }

        uiView.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.region = mapView.region
        }
    }
}

struct Map: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)
    )

    var body: some View {
        MapView(region: $region, emergencyMedicalCenters: [
            EmergencyMedicalCenter(name: "Robert Wood Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)),
            EmergencyMedicalCenter(name: "Thomas Gold Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7306, longitude: -73.9352)),
            EmergencyMedicalCenter(name: "Grace Memorial Medical Center", coordinate: CLLocationCoordinate2D(latitude: 40.7518, longitude: -73.9765)),
            EmergencyMedicalCenter(name: "Cityview General Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7580, longitude: -73.9855)),
            EmergencyMedicalCenter(name: "Central Park Health Center", coordinate: CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9840)),
            EmergencyMedicalCenter(name: "MetroMed Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7549, longitude: -73.9840)),
            EmergencyMedicalCenter(name: "Hudson Bay Medical Center", coordinate: CLLocationCoordinate2D(latitude: 40.7456, longitude: -74.0079)),
            EmergencyMedicalCenter(name: "Liberty Regional Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7493, longitude: -73.9922)),
            EmergencyMedicalCenter(name: "Harborview Emergency Care", coordinate: CLLocationCoordinate2D(latitude: 40.7590, longitude: -73.9845)),
            EmergencyMedicalCenter(name: "Uptown Community Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7463, longitude: -73.9846)),
            // Add 20 more random names and coordinates ...

            // Medical Centers in Jersey City
            EmergencyMedicalCenter(name: "Meadowside General Hospital", coordinate: CLLocationCoordinate2D(latitude: 40.7282, longitude: -74.0776)),
            EmergencyMedicalCenter(name: "Bayfront Regional Medical Center", coordinate: CLLocationCoordinate2D(latitude: 40.7178, longitude: -74.0431)),
            // ... Add more random names and coordinates ...
        ])
        .edgesIgnoringSafeArea(.all)
    }
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map()
    }
}
