//
//  LocationPickerViewController.swift
//  Hypto
//
//  Created by Vigneshkumar G on 09/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import UIKit
import CoreLocation

struct Location {
    let latitude: Double
    let longitude: Double
    let address: String
}

protocol LocationPickerDelegate: class {
    func locationPicked(location: Location)
}

class LocationPickerViewController: UIViewController, Storyboarded
{
    private var locationManager: CLLocationManager!
    
    weak var delegate: LocationPickerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchBar: UISearchBar = {
        let s = UISearchBar(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 44))
        s.placeholder = "Start typing"
        s.delegate = self
        return s
    }()
    
    private var predictions: [Prediction] = []
    private var currentLocation: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoreLocation()
        
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupCoreLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        if let clLocation = currentLocation {
            self.delegate?.locationPicked(location: Location.init(latitude: clLocation.coordinate.latitude, longitude: clLocation.coordinate.longitude, address: "Current Location"))
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func sendLocation(placeID: String)  {
        let request = PlaceDetailsFetchRequest.init(placeid: placeID)
        request.execute { result in
            DispatchQueue.main.async {
                if let value = result.get() {
                    self.delegate?.locationPicked(location: Location.init(latitude: value.latitude, longitude: value.longitude, address: value.formattedAddress))
                    self.navigationController?.popViewController(animated: true)
                }
                if let error = result.error() {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchPlaces(searchText: String) {
        let request = PlacesFetchRequest.init(searchString: searchText)
        request.execute { result in
            DispatchQueue.main.async {
                if let value = result.get() {
                    self.predictions = value.predictions
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension LocationPickerViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        cell.textLabel?.text = predictions[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendLocation(placeID: predictions[indexPath.row].placeID)
    }
}

extension LocationPickerViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchPlaces(searchText: searchBar.text ?? "")
    }
}

extension LocationPickerViewController: CLLocationManagerDelegate
{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
