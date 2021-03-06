//
//  DetailRestaurentUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class ListRestaurentUserViewController: UIViewController {
    
    @IBOutlet weak var restaurantSearchBar: UISearchBar!
    @IBOutlet weak var typeRestaurantLabel: UILabel!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var restaurentTableview: UITableView!
    
    var typeRestaurant: String?
    var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()
    var filterData: [InfoRestaurant] = [InfoRestaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantSearchBar.delegate = self
        LoadRestaurants()
        setUpTableView()
        setUpAction()
    }
    
    func LoadRestaurants() {
        guard let typeRestaurant = typeRestaurant else { return }
        FirebaseManager.shared.getListRestaunt(typeRestaurant: typeRestaurant) { (infoRestaurant) in
            self.listRestaurant = infoRestaurant
            self.filterData = infoRestaurant
            DispatchQueue.main.async {
                self.typeRestaurantLabel.text = typeRestaurant
                self.restaurentTableview.reloadData()
            }
        }
    }
    
    func setUpTableView() {
        restaurentTableview.delegate = self
        restaurentTableview.dataSource = self
        restaurentTableview.register(UINib(nibName: "RestaurentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        closeImageView.isUserInteractionEnabled = true
        self.closeImageView.addGestureRecognizer(gesture)
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ListRestaurentUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailRestaurantUserViewController()
        vc.infoRestaurant = listRestaurant[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListRestaurentUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? RestaurentsTableViewCell else { return RestaurentsTableViewCell() }
        cell.setUpCell(infoRestaurant: filterData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension ListRestaurentUserViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData = []
        
        if searchText == "" {
            filterData = listRestaurant
        } else {
            for restaurant in listRestaurant {
                if restaurant.name.lowercased().contains(searchText.lowercased()) {
                    filterData.append(restaurant)
                }
            }
        }
        self.restaurentTableview.reloadData()
    }
}

