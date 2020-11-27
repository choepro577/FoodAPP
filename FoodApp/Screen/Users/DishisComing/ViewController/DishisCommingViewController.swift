//
//  DishisCommingViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/27/20.
//

import UIKit
import SwiftGifOrigin

class DishisCommingViewController: UIViewController {

    @IBOutlet weak var processShipperImageView: UIImageView!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var dishTableView: UITableView!
    @IBOutlet weak var cookingImageView: UIImageView!
    @IBOutlet weak var statusRestaurant: UILabel!
    @IBOutlet weak var statusWaitingLabel: UILabel!
    
    var infoRestaurant: InfoRestaurant?
    var listInfoDistOrder: [InfoCard] = [InfoCard]()
    var infoOrder: InfoOrderofUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getInfoCart()
        setUpTableView()
        setUpAction()
        getInfoOrder()
    }
    
    func getInfoOrder() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getInfoOrder(uidRestaurant: infoRestaurant.uid) { (infoOrder) in
            if infoOrder.status == "2" {
                self.statusRestaurant.text = "Restaurant is delivered"
                self.statusWaitingLabel.text = "Shipper is Coming"
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
 
