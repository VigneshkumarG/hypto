//
//  ViewController.swift
//  Hypto
//
//  Created by Vigneshkumar G on 09/03/19.
//  Copyright © 2019 viki. All rights reserved.
//

import UIKit


class RestaurantsListViewController: UIViewController, Storyboarded
{
    private let location: Location = Location(latitude: 12.23243, longitude: 12.24323, address: "Chennai")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    private var list: [Restarunt] = []
    
    lazy var searchBar: UISearchBar = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        let s = UISearchBar(frame: frame)
        s.searchBarStyle = .minimal
        s.placeholder = "Search restaurants"
        s.delegate = self
        return s
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        loadRestaurants()
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        let locationVC = LocationPickerViewController.instantiate()
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    private func loadRestaurants() {
        let request = RestaruntFetchRequest.init(latitude: self.location.latitude, longitude: self.location.longitude, radius: 50)
        
        request.execute { result in
            if let error = result.error() {
                print("error while fetch \(error)")
                return
            }
            if let value = result.get() {
                self.list = value.restaurants
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                return
            }
        }
    }
}

extension RestaurantsListViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableCell", for: indexPath) as! RestaurantTableCell
        cell.set(restaurant: list[indexPath.row])
        return cell
    }
}


extension RestaurantsListViewController: UISearchBarDelegate
{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}


class RestaurantTableCell: UITableViewCell {
  
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    private var model: Restarunt? = nil
    
    func set(restaurant: Restarunt)  {
        self.model = restaurant
        nameLabel.text = restaurant.name
        ratingLabel.text = restaurant.ratingText
        photoView.image = UIImage(named: "template.jpg")
//        guard let _ = URL(string: restaurant.featured_image) else {
//            photoView.image = UIImage(named: "template")
//            return
//        }
//        let request = HTTPRequest(url: restaurant.featured_image, parameters: [:])
//        request.execute { result in
//            if let data = result.get(), let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    if self.model == restaurant {
//                        self.photoView.image = image
//                    }
//                }
//            }
//        }
    }
}
