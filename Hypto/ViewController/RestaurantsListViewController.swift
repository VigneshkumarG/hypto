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
    private var location: Location = Location(latitude: 12.23243, longitude: 12.24323, address: "Chennai")
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    private var list: [Restarunt] = [] {
        didSet{
            filteredList = list
        }
    }
    private var listResponse: RestaruntResponse? = nil
    private var filteredList: [Restarunt] = []
    private var loadMoreTriggered: Bool = false
    
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
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(refreshControlChanged), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.delegate = self
        navigationController?.navigationBar.isHidden = true
        loadRestaurants()
    }

    @IBAction func refreshControlChanged() {
        loadRestaurants()
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        let locationVC = LocationPickerViewController.instantiate()
        locationVC.delegate = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    private func loadRestaurants(start: Int = 0) {
        let request = RestaruntFetchRequest.init(latitude: self.location.latitude, longitude: self.location.longitude, radius: 50, start: start)
        
        request.execute { result in
            DispatchQueue.main.async {
                self.loadMoreTriggered = false
                self.tableView.refreshControl?.endRefreshing()
                if let error = result.error() {
                    print("error while fetch \(error)")
                    return
                }
                if let value = result.get() {
                    self.listResponse = value
                    self.list.append(contentsOf: value.restaurants)
                    self.tableView.reloadData()
                    return
                }
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
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableCell", for: indexPath) as! RestaurantTableCell
        cell.set(restaurant: filteredList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ( list.count - 1) {
            // last cell
            if let listResponse = listResponse, listResponse.hasLoadMore, !loadMoreTriggered {
                loadMoreTriggered = true
                let nextStart = listResponse.resultsStart + listResponse.resultShown
                loadRestaurants(start: nextStart)
            }
        }
    }
}


extension RestaurantsListViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.count > 0 {
            filteredList = list.filter({ res in
                if res.name.contains(text) {
                    return true
                }
                return false
            })
        }else{
            filteredList = list
        }
        tableView.reloadData()
    }
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension RestaurantsListViewController: LocationPickerDelegate
{
    func locationPicked(location: Location) {
        self.location = location
        loadRestaurants()
        locationLabel.text = location.address
    }
}
