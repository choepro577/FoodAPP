//
//  HomeRestaurantViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit
import Kingfisher

class HomeRestaurantViewController: UIViewController {

    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var infomationRestaurantView: UIView!
    
    var listOrder: [InfoOrderofUser] = [InfoOrderofUser]()
    var Restaurant: InfoRestaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        getListOrder()
        setUpTableView()
        getInforRestaurant()
        setUpAction()
    }
    
    func getListOrder() {
        FirebaseManager.shared.getlistOrder() { (listOrder) in
            self.listOrder = listOrder
            DispatchQueue.main.async {
                self.ordersTableView.reloadData()
            }
        }
    }
    
    func setUpAction() {
        let infomationRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.setUpFullInfoRestaurant))
        self.infomationRestaurantView.addGestureRecognizer(infomationRestaurantGesture)
    }
    
    @objc func setUpFullInfoRestaurant(sender : UITapGestureRecognizer) {
        let vc = AddInfoRestaurantViewController()
        self.present(vc, animated: true)
    }
    
    func getInforRestaurant() {
        FirebaseManager.shared.getInfoRestaurant() { (infoResutl) in
            self.Restaurant = infoResutl
            guard let infoRestaurant = self.Restaurant else { return }
            let resource = ImageResource(downloadURL: URL(string: infoRestaurant.imageLink)!, cacheKey: infoRestaurant.imageLink)
            self.restaurantImageView.kf.setImage(with: resource)
            self.nameRestaurantLabel.text = infoRestaurant.name
            self.titleRestaurantLabel.text = infoRestaurant.title
            self.addressRestaurantLabel.text = infoRestaurant.address
        }
    }
   
    func setUpTableView() {
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "ListOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    @IBAction func editcatagory(_ sender: Any) {
        let vc = RestaurentHomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeRestaurantViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailOrderViewController()
        vc.listOrder = listOrder[indexPath.row]
        vc.infoRestaurant = Restaurant
        vc.status = listOrder[indexPath.row].status
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeRestaurantViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? ListOrderTableViewCell else { return ListOrderTableViewCell() }
        cell.setUpCell(infoOrder: listOrder[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
