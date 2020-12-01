//
//  DetailsRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit
import Kingfisher

class DetailsRestaurentViewController: UIViewController {
    
    @IBOutlet weak var infoRestaurantView: UIView!
    @IBOutlet weak var addressRestaurantLabel: UILabel!
    @IBOutlet weak var titleRestaurantLabel: UILabel!
    @IBOutlet weak var nameRestaurantLabel: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var addPromoView: UIView!
    @IBOutlet weak var promosTableview: UITableView!
    
    var infoRestaurant: InfoRestaurant?
    var typeRestaurant: String?
    var listPromo: [InfoPromo] = [InfoPromo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListPromo()
        setUpPromosTableView()
        setUpInfoRetaurant()
        setUpAction()
        setUpUI()
    }
    
    func setUpUI() {
        infoRestaurantView.layer.cornerRadius = infoRestaurantView.frame.width/20
        infoRestaurantView.layer.shadowRadius = 5
        infoRestaurantView.layer.shadowColor = UIColor.black.cgColor
        infoRestaurantView.layer.shadowOffset = CGSize (width: 10, height: 10)
        infoRestaurantView.layer.shadowOpacity = 0.1
        infoRestaurantView.layer.borderWidth = 2
        infoRestaurantView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addPromoAction))
        self.addPromoView.addGestureRecognizer(gesture)
    }
    
    func setUpInfoRetaurant() {
        guard let infoRestaurant = infoRestaurant else { return }
        nameRestaurantLabel.text = infoRestaurant.name
        titleRestaurantLabel.text = infoRestaurant.title
        addressRestaurantLabel.text = infoRestaurant.address
        let resource = ImageResource(downloadURL: URL(string: infoRestaurant.imageLink)!, cacheKey: infoRestaurant.imageLink)
        restaurantImageView.kf.setImage(with: resource)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func getListPromo() {
        guard let uid = infoRestaurant?.uid else { return }
        FirebaseManager.shared.getListPromoRestaurant(uid: uid) { (listPromo) in
            self.listPromo = listPromo
            DispatchQueue.main.async {
                self.promosTableview.reloadData()
            }
        }
    }
    
    @objc func addPromoAction(sender : UITapGestureRecognizer) {
       let vc = PopAddPromoViewController()
        vc.infoRestaurant = infoRestaurant
        self.present(vc, animated: true)
    }

    func setUpPromosTableView() {
        promosTableview.delegate = self
        promosTableview.dataSource = self
        promosTableview.register(UINib(nibName: "PromosTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
}

extension DetailsRestaurentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let uid = infoRestaurant?.uid, let typeRestaurant = typeRestaurant else { return }
            print(uid,typeRestaurant,listPromo[indexPath.row].namePromo)
            FirebaseManager.shared.deletePromo(codePromo: listPromo[indexPath.row].codePromo, typeRestaurant: typeRestaurant, uid: uid ){ (success, error) in
                if (success) {
                    self.showAlert("Notification", "Deleted")
                } else {
                    return
                }
            }
        }
    }
    
}

extension DetailsRestaurentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPromo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? PromosTableViewCell else { return PromosTableViewCell() }
        cell.setUpCell(infoPromo: listPromo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
