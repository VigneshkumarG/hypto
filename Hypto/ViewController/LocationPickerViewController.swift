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
    
    private lazy var headerButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44)
        let b = UIButton(frame: frame)
        b.backgroundColor = UIColor.white
        b.setTitleColor(self.view.tintColor, for: .normal)
        b.titleLabel?.textAlignment = .left
        b.setTitle("Use Current location", for: .normal)
        b.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        return b
    }()
    
    var places = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerButton
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func currentLocationButtonTapped()  {
        sendLocation()
    }
    
    func sendLocation()  {
//        delegate?.locationPicked(location: Location(latitude: "", longitude: "test", address: "test"))
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
