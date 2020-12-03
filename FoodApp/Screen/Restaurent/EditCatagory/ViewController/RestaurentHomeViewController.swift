//
//  RestaurentHomeViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit
import Kingfisher

class RestaurentHomeViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var infomationRestaurantView: UIView!
    @IBOutlet weak var restaurentCatagoryTableView: UITableView!
    @IBOutlet weak var catagoryView: UIView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var listDish: [InfoDish] = [InfoDish]()
    var Restaurant: InfoRestaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewCell()
        setUpUI()
        setUpAction()
    }
    
    func setUpTableViewCell() {
        restaurentCatagoryTableView.delegate = self
        restaurentCatagoryTableView.dataSource = self
        restaurentCatagoryTableView.register(UINib(nibName: "RestaurentCatagoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func setUpUI() {
        infomationRestaurantView.layer.cornerRadius = infomationRestaurantView.frame.width/20
        infomationRestaurantView.layer.shadowRadius = 5
        infomationRestaurantView.layer.shadowColor = UIColor.black.cgColor
        infomationRestaurantView.layer.shadowOffset = CGSize (width: 10, height: 10)
        infomationRestaurantView.layer.shadowOpacity = 0.1
        
        catagoryView.layer.cornerRadius = catagoryView.frame.width/20
        catagoryView.layer.shadowRadius = 5
        catagoryView.layer.shadowColor = UIColor.black.cgColor
        catagoryView.layer.shadowOffset = CGSize (width: 10, height: 10)
        catagoryView.layer.shadowOpacity = 0.1
        
        addButton.layer.cornerRadius = addButton.frame.width/5
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize (width: 10, height: 10)
        addButton.layer.shadowOpacity = 0.1
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        self.navigationController?.isNavigationBarHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addRestaurent))
        self.catagoryView.addGestureRecognizer(gesture)
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(imageDismissRestaurantGesture)
        getInfoRestaurant()
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getInfoRestaurant() {
        FirebaseManager.shared.getInfoRestaurant() { (infoResutl) in
            self.Restaurant = infoResutl
            guard let Restaurant = self.Restaurant else { return }
            let resource = ImageResource(downloadURL: URL(string: Restaurant.imageLink)!, cacheKey: Restaurant.imageLink)
            self.restaurantImageView.kf.setImage(with: resource)
            self.nameRestaurantLabel.text = Restaurant.name
            self.titleRestaurantLabel.text = Restaurant.title
            self.addressRestaurantLabel.text = Restaurant.address
        }
        
        FirebaseManager.shared.getListDishRestaurant(){ (listDishResult) in
            self.listDish = listDishResult
            DispatchQueue.main.async {
                self.restaurentCatagoryTableView.reloadData()
            }
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
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
            FirebaseManager.shared.deleteCatagory(nameDish: listDish[indexPath.row].nameDish) { (success, error) in
                if (success) {
                    self.showAlert("Notification", "Deleted")
                } else {
                    return
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DishViewController()
        vc.nameDish = listDish[indexPath.row].nameDish
        self.present(vc, animated: true)
    }
    
}

extension RestaurentHomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDish.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? RestaurentCatagoryTableViewCell else { return RestaurentCatagoryTableViewCell() }
        cell.setUpInfoCell(infoDish: listDish[indexPath.row])
        let resource = ImageResource(downloadURL: URL(string: listDish[indexPath.row].imageLink)!, cacheKey: listDish[indexPath.row].imageLink)
        cell.dishImageView.kf.setImage(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
