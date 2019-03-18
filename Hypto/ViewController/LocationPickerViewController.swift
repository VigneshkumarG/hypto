//
//  LocationPickerViewController.swift
//  Hypto
//
//  Created by Vigneshkumar G on 09/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import UIKit

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
    
    weak var delegate: LocationPickerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var searchBar: UISearchBar = {
        let s = UISearchBar(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 44))
        s.placeholder = "Start typing"
        s.delegate = self
        return s
    }()
    
    var places = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func currentLocationTapped(_ sender: Any) {
        sendLocation()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func sendLocation()  {
//        delegate?.locationPicked(location: Location(latitude: "", longitude: "test", address: "test"))
    }
    
    private func fetchPlaces(searchText: String) {
        let request = PlacesFetchRequest.init(searchString: searchText)
        request.execute { result in
            DispatchQueue.main.async {
                if let value = result.get() {
                    self.places = value.predictions.map({ prediction -> String  in
                        return prediction.description
                    })
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
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendLocation()
    }
}

extension LocationPickerViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchPlaces(searchText: searchBar.text ?? "")
    }
}
