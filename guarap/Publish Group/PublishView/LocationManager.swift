import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastKnownLocation: CLLocation?
    @Published var showError = false // Para mostrar el error
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestAlwaysAuthorization() // Cambio aquí
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error obteniendo ubicación: \(error.localizedDescription)")
        showError = true // Mostrar el error
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            print("Se autorizó el uso de la ubicación cuando la app está en uso")
            locationManager.startUpdatingLocation()
        case .denied:
            print("El usuario denegó el acceso a la ubicación")
            // Aquí puedes mostrar un mensaje o guiar al usuario a configurar los permisos en Ajustes
        case .notDetermined:
            print("Los permisos de ubicación aún no se han determinado")
            locationManager.requestAlwaysAuthorization() // Cambio aquí
        default:
            break
        }
    }
}
