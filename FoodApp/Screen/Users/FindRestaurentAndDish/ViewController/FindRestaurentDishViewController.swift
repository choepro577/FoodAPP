//
//  FindRestaurentDishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class FindRestaurentDishViewController: UIViewController {

    @IBOutlet weak var listRestaurantTableView: UITableView!
    @IBOutlet weak var dishAndRestaurentSearchBar: UISearchBar!
    
    var infoRestaurent: [InfoRestaurant] = [InfoRestaurant]()
    var filterData: [InfoRestaurant] = [InfoRestaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishAndRestaurentSearchBar.delegate = self
        getListRestaurant()
        setUpTableView()
        self.dishAndRestaurentSearchBar.backgroundImage = UIImage()
    }

    @IBAction func cancelActionButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getListRestaurant() {
        FirebaseManager.shared.getAllRestaurant() { (listRestaurant) in
            self.infoRestaurent = listRestaurant
            self.filterData = listRestaurant
            DispatchQueue.main.async {
                self.listRestaurantTableView.reloadData()
            }
        }
    }
    
    func setUpTableView() {
        listRestaurantTableView.delegate = self
        listRestaurantTableView.dataSource = self
        listRestaurantTableView.register(UINib(nibName: "restaurantInUserTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
}

extension FindRestaurentDishViewController: UITableViewDelegate {
    
}

extension FindRestaurentDishViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? restaurantInUserTableViewCell else { return restaurantInUserTableViewCell() }
        cell.setUpCell(infoRestaurant: filterData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension FindRestaurentDishViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        if searchText == "" {
            filterData = infoRestaurent
        } else {
            for restaurant in infoRestaurent {
                if restaurant.name.lowercased().contains(searchText.lowercased()) {
                    filterData.append(restaurant)
                }
            }
        }
        self.listRestaurantTableView.reloadData()
    }
}
