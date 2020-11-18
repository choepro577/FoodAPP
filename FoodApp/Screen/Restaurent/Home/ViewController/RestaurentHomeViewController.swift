//
//  RestaurentHomeViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit
import Kingfisher

class RestaurentHomeViewController: UIViewController {
    
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var infomationRestaurantView: UIView!
    @IBOutlet weak var restaurentCatagoryTableViewCell: UITableView!
    @IBOutlet weak var catagoryView: UIView!
    
    var listRestaurant: InfoRestaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        setUpUI()
    }
    
    func setUpTableViewCell() {
        restaurentCatagoryTableViewCell.delegate = self
        restaurentCatagoryTableViewCell.dataSource = self
        restaurentCatagoryTableViewCell.register(UINib(nibName: "RestaurentCatagoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func setUpUI() {
        self.navigationController?.isNavigationBarHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addRestaurent))
        self.catagoryView.addGestureRecognizer(gesture)
        
        let infomationRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.setUpFullInfoRestaurant))
        self.infomationRestaurantView.addGestureRecognizer(infomationRestaurantGesture)
        getInfoRestaurant()
    }
    
    func getInfoRestaurant() {
        FirebaseManager.shared.getInfoRestaurant() { (infoResutl) in
            self.listRestaurant = infoResutl
            print(infoResutl)
            guard let listRestaurant = self.listRestaurant else { return }
            let resource = ImageResource(downloadURL: URL(string: listRestaurant.imageLink)!, cacheKey: listRestaurant.imageLink)
            print(resource)
            self.restaurantImageView.kf.setImage(with: resource)
            self.nameRestaurantLabel.text = listRestaurant.name
            self.titleRestaurantLabel.text = listRestaurant.title
            self.addressRestaurantLabel.text = listRestaurant.address
        }
    }
    
    @objc func setUpFullInfoRestaurant(sender : UITapGestureRecognizer) {
        let vc = AddInfoRestaurantViewController()
        self.present(vc, animated: true)
    }
    
    @objc func addRestaurent(sender : UITapGestureRecognizer) {
        let vc = AddCatagoryViewController()
        self.present(vc, animated: true)
    }
    
    @IBAction func statisticalInfoActionButton(_ sender: Any) {
        let vc = StatisticallViewController()
        self.present(vc, animated: true)
    }
}

extension RestaurentHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DishViewController()
        self.present(vc, animated: true)
    }
    
}

extension RestaurentHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? RestaurentCatagoryTableViewCell else { return RestaurentCatagoryTableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
