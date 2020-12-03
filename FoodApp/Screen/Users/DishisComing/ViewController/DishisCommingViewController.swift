//
//  DishisCommingViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit
import SwiftGifOrigin

class DishisCommingViewController: UIViewController {

    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var dishTableView: UITableView!
    @IBOutlet weak var cookingImageView: UIImageView!
    @IBOutlet weak var statusRestaurant: UILabel!
    @IBOutlet weak var statusWaitingLabel: UILabel!
    
    var infoRestaurant: InfoRestaurant?
    var listInfoDistOrder: [InfoCard] = [InfoCard]()
    var infoOrder: InfoOrderofUser?
    var dateTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getInfoCart()
        setUpTableView()
        setUpAction()
        getInfoOrder()
        getHistoryOrder()
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            guard let infoRestaurant = self.infoRestaurant else { return }
            FirebaseManager.shared.deleteOrderStatus(uidRestaurant: infoRestaurant.uid) { (suscess, error) in
                if (suscess) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func getHistoryOrder() {
        guard let dateTime = self.dateTime else { return }
        FirebaseManager.shared.getInfoHistoryUser(dateTime: dateTime) { (historyOrder) in
            if historyOrder.status == "4" {
                self.statusRestaurant.text = "Thanks for your order"
                self.statusWaitingLabel.text = "Enjoy your meal"
                self.cookingImageView.image = UIImage.gif(name: "status4")
                self.dishTableView.isHidden = true
                self.orderLabel.isHidden = true
            }
            if historyOrder.status == "5" {
                self.statusRestaurant.text = "Sorry Restaurant has just run out of food"
                self.statusWaitingLabel.text = "You can order something else"
                self.cookingImageView.image = UIImage.gif(name: "sorry")
                self.dishTableView.isHidden = true
                self.orderLabel.isHidden = true
            }
        }
    }
    
    
    func getInfoOrder() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getInfoOrder(uidRestaurant: infoRestaurant.uid) { (infoOrder) in
            print(infoOrder.status)
            self.infoOrder = infoOrder
        
            if infoOrder.status == "2" {
                self.statusRestaurant.text = "Restaurant is delivered"
                self.statusWaitingLabel.text = "Shipper is Coming"
                self.cookingImageView.image = UIImage.gif(name: "shipper")
            }
            if infoOrder.status == "1" {
                self.statusRestaurant.text = "Restaurant Cooking"
                self.statusWaitingLabel.text = "Wait for the restaurant to prepare food"
                self.cookingImageView.image = UIImage.gif(name: "cooking")
            }
        }
    }
    
    func getInfoCart() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getInfoCard(uidRestaurant: infoRestaurant.uid) { (countDish, totalPrice, listInfocart) in
            self.listInfoDistOrder = listInfocart
            DispatchQueue.main.async {
                self.dishTableView.reloadData()
            }
        }
    }
    
    func setUpTableView() {
        dishTableView.delegate = self
        dishTableView.dataSource = self
        dishTableView.register(UINib(nibName: "dishOrderedTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func setUpAction() {
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(imageDismissRestaurantGesture)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

    func setUpUI() {
        guard let infoRestaurant = infoRestaurant  else { return }
        nameRestaurantLabel.text = infoRestaurant.name
        cookingImageView.image = UIImage.gif(name: "cooking")
       // processShipperImageView.image = UIImage.gif(name: "shipper")
    }
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        
        guard let infoOrder = self.infoOrder else { return }
        if infoOrder.status == "2" {
            let alertController = UIAlertController(title: "Notification", message: "Can't Cancel Order", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            self.showAlert("Notification", "Are you sure you want to cancel?")
        }
    }
    
}

extension DishisCommingViewController: UITableViewDelegate {
    
}

extension DishisCommingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listInfoDistOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? dishOrderedTableViewCell else { return dishOrderedTableViewCell() }
        cell.setUpCell(infoCard: listInfoDistOrder[indexPath.row])
        return cell
    }
    
    
}
 
