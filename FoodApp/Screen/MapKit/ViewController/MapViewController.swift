//
//  MapViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/2/20.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func getAddress(address: String) 
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var subAddressLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let regionInMeters: Double = 10000
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    var previousLocation: CLLocation?
    let locationManager = CLLocationManager()
    var delegate :MapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkLocationServices()
        setUpAction()
        setUpAction()
        self.navigationController?.isNavigationBarHidden = false
        mapView.delegate = self
        mapView.register(myAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        let locationSearchTable = resultSearchMapViewController()
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as? UISearchResultsUpdating
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for place"
        self.navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func setUpAction() {
        let confirmViewRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.confirmAction))
        self.confirmView.addGestureRecognizer(confirmViewRestaurantGesture)
    }
    
    @objc func confirmAction(sender : UITapGestureRecognizer) {
        FirebaseManager.shared.addAddress(address: self.addressLabel.text ?? "", subAddress: self.subAddressLabel.text ?? "") {(suscess, error) in
            var message: String = ""
            if (suscess) {
                message = "Confirm suscess"
                self.showAlert("Notification", message)
            } else {
                //
            }
        }
        
        delegate?.getAddress(address: "\(self.addressLabel.text ?? "")")
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error { return }
            guard let placemark = placemarks?.first else { return }
            let wardplacemark = placemark.subLocality ?? ""
            let cityplacemark = placemark.administrativeArea ?? ""
            let districtplacemark = placemark.subAdministrativeArea ?? ""
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let ward = wardplacemark.description
            let city = cityplacemark.description
            let district = districtplacemark.description
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(streetNumber) \(streetName)"
                self.subAddressLabel.text = "\(ward) \(district) \(city)"
            }
        }
    }
}

protocol HandleMapSeach {
    func dropPinZoomIN(placemark: MKPlacemark)
}

extension MapViewController: HandleMapSeach {
    func dropPinZoomIN(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let anonatation = MKPointAnnotation()
        anonatation.coordinate = placemark.coordinate
        
        if let _ = placemark.locality,
           let _ = placemark.administrativeArea {
            anonatation.subtitle = "(city) (state)"
        }
        mapView.addAnnotation(anonatation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

