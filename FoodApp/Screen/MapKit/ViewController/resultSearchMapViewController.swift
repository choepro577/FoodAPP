//
//  resultSearchMapViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/2/20.
//

import UIKit
import MapKit

class resultSearchMapViewController: UIViewController {
    
    @IBOutlet weak var resultSearchTableView: UITableView!
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate: HandleMapSeach? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUptableView()
    }
    
    func setUptableView() {
        self.resultSearchTableView.delegate = self
        self.resultSearchTableView.dataSource = self
        self.resultSearchTableView.register(UINib(nibName: "addressTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " ": ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", ": ""
        
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " ": ""
        
        let addressLine = String(format: "%@%@%@%@%@%@%@",
                                 // Street Number
                                 selectedItem.subThoroughfare ?? "",
                                 firstSpace,
                                 // Street Name
                                 selectedItem.thoroughfare ?? "",
                                 comma,
                                 // City
                                 selectedItem.locality ?? "",
                                 secondSpace,
                                 // State
                                 selectedItem.administrativeArea ?? "")
        return addressLine
    }
    
}

extension resultSearchMapViewController: UITableViewDelegate {
    
}

extension resultSearchMapViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? addressTableViewCell else { return addressTableViewCell() }
        let selectedItem = matchingItems[indexPath.row].placemark
        print(selectedItem)
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIN(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension resultSearchMapViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            
            self.resultSearchTableView.reloadData()
            
        }
    }
}
