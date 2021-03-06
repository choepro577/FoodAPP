//
//  HomeRestaurantViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit
import Kingfisher

class HomeRestaurantViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var infomationRestaurantView: UIView!
    
    var listOrder: [InfoOrderofUser] = [InfoOrderofUser]()
    var Restaurant: InfoRestaurant?
    
    var date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        getListOrder()
        setUpTableView()
        getInforRestaurant()
        setUpAction()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpUI() {
        infomationRestaurantView.layer.cornerRadius = infomationRestaurantView.frame.width/20
        infomationRestaurantView.layer.shadowRadius = 5
        infomationRestaurantView.layer.shadowColor = UIColor.black.cgColor
        infomationRestaurantView.layer.shadowOffset = CGSize (width: 10, height: 10)
        infomationRestaurantView.layer.shadowOpacity = 0.1
        
        addButton.layer.cornerRadius = addButton.frame.width/5
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize (width: 10, height: 10)
        addButton.layer.shadowOpacity = 0.1
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
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
        self.navigationController?.pushViewController(vc, animated: true)
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
        guard let infoRestaurant = self.Restaurant else { return }
        if infoRestaurant.address == "" {
            self.showAlert("Notification", "You must setup restaurant information")
        } else {
            let vc = RestaurentHomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if listOrder[indexPath.row].status == "1" {
                guard let infoRestaurant = self.Restaurant else { return }
                FirebaseManager.shared.deleteOrder(uidUser: listOrder[indexPath.row].id, status: "5", name: listOrder[indexPath.row].name, addressRestaurant: infoRestaurant.address, totalPrice: listOrder[indexPath.row].totalPrice, dateTime: listOrder[indexPath.row].dateTime) { (success, error) in
                    if (success) {
                        self.showAlert("Notification", "Deleted")
                    } else {
                        return
                    }
                }
            } else {
                guard let infoRestaurant = self.Restaurant else { return }
                FirebaseManager.shared.deleteOrder(uidUser: listOrder[indexPath.row].id, status: "4", name: listOrder[indexPath.row].name, addressRestaurant: infoRestaurant.address, totalPrice: listOrder[indexPath.row].totalPrice, dateTime: listOrder[indexPath.row].dateTime) { (success, error) in
                    if (success) {
                        self.showAlert("Notification", "Deleted")
                    } else {
                        return
                    }
                }
            }
        }
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
