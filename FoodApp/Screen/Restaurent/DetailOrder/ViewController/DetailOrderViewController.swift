//
//  DetailOrderViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/28/20.
//

import UIKit

class DetailOrderViewController: UIViewController {
    
    @IBOutlet weak var nameRestaurant: UILabel!
    @IBOutlet weak var deliveredView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var listDishOrderTableView: UITableView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var addressUserLabel: UILabel!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var idOrderLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    
    var listInfoDistOrder: [InfoCard] = [InfoCard]()
    var listOrder: InfoOrderofUser?
    var infoRestaurant: InfoRestaurant?
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoCart()
        setUpTableView()
        setUpAction()
        setUpUI()
    }
    
    func getInfoCart() {
        guard let listOrder = listOrder  else { return }
        FirebaseManager.shared.getInfoInRestaurantCard(uidUser: listOrder.id) { (countDish, totalPrice, listInfocart) in
            self.listInfoDistOrder = listInfocart
            DispatchQueue.main.async {
                // self.totalPriceDishsLabel.text = "\(totalPrice)"
                self.idOrderLabel.text = listOrder.id
                self.nameUserLabel.text = listOrder.name
                self.addressUserLabel.text = listOrder.address
                self.phoneNumberLabel.text = listOrder.phone
                self.countDishLabel.text = "\(countDish) Dish"
                self.totalMoneyLabel.text = "\(totalPrice + 15000)"
                self.listDishOrderTableView.reloadData()
            }
        }
    }
    
    func setUpUI() {
        guard let infoRestaurant = infoRestaurant  else { return }
        nameRestaurant.text = infoRestaurant.name
        deliveredView.layer.cornerRadius = deliveredView.frame.width/20
        deliveredView.layer.shadowRadius = 5
        deliveredView.layer.shadowColor = UIColor.black.cgColor
        deliveredView.layer.shadowOffset = CGSize (width: 10, height: 10)
        deliveredView.layer.shadowOpacity = 0.1
        deliveredView.layer.borderWidth = 2
        deliveredView.layer.borderColor = UIColor.white.cgColor
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func setUpAction() {
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(imageDismissRestaurantGesture)
        
        let deliveredRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.deliveredAction))
        self.deliveredView.addGestureRecognizer(deliveredRestaurantGesture)
        
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deliveredAction(sender : UITapGestureRecognizer) {
        let vc = ListOrderTableViewCell()
        guard let listOrder = self.listOrder  else { return }
        FirebaseManager.shared.getInfoDetailOrderToCheckOrder(uidUser: listOrder.id) { (infoCart) in
            guard let listOrder = self.listOrder  else { return }
            if infoCart.status == "3"
            {
                self.showAlert("Error", "The order has been canceled")
            } else {
                if self.status == "1" {
                    vc.isComing(uidUser: listOrder.id, status: self.status ?? "")
                    self.status = "2"
                } else {
                    vc.isComing(uidUser: listOrder.id, status: self.status ?? "")
                    self.status = "1"
                }
            }
        }
    }
    
    func setUpTableView() {
        listDishOrderTableView.delegate = self
        listDishOrderTableView.dataSource = self
        listDishOrderTableView.register(UINib(nibName: "DishOrderInRestaurantTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
}

extension DetailOrderViewController: UITableViewDelegate {
    
}

extension DetailOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listInfoDistOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? DishOrderInRestaurantTableViewCell else { return DishOrderInRestaurantTableViewCell() }
            cell.setUpCell(infoDishOrder: listInfoDistOrder[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
