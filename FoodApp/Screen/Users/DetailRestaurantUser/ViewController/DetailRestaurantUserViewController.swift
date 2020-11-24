//
//  DetailRestaurantUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/24/20.
//

import UIKit

class DetailRestaurantUserViewController: UIViewController {
    
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var lishDishTableView: UITableView!
    var listDish: [InfoDish] = [InfoDish]()
    var infoRestaurant: InfoRestaurant?
    var listDishDetail: [[InfoDishDetail]] = [[InfoDishDetail]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListDish()
        setUpAction()
        setUpTableView()
    }
    
    func setUpAction() {
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissRestaurantGesture)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpTableView() {
        lishDishTableView.delegate = self
        lishDishTableView.dataSource = self
        lishDishTableView.register(UINib(nibName: "ListDishTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func getListDish() {
        guard let uid = infoRestaurant?.uid else { return }
        FirebaseManager.shared.getListDishRestaurantForUser(uid: uid) { (infoDish) in
            self.listDish = infoDish
            self.getListDetail(listDish: infoDish) {(resutl) in
                print("srssssssss",resutl)
            }
            for infoDish in self.listDish {
                FirebaseManager.shared.getListDishDetailsForUser(uid: uid,nameDish: infoDish.nameDish) { (dishDetail) in
                    self.listDishDetail.append(dishDetail)
                    //print(self.listDishDetail)
                    DispatchQueue.main.async {
                        self.lishDishTableView.reloadData()
                    }
                }
            }
           // print(self.listDishDetail)
        }
    }
    
    func getListDetail(listDish: [InfoDish], completionBlock: @escaping (_ InfoDishDetail: [[InfoDishDetail]]) -> Void) {
        guard let uid = infoRestaurant?.uid else { return }
        var distDetails: [[InfoDishDetail]] = [[InfoDishDetail]]()
        for infoDish in listDish {
            FirebaseManager.shared.getListDishDetailsForUser(uid: uid,nameDish: infoDish.nameDish) { (dishDetail) in
                distDetails.append(dishDetail)
                completionBlock(distDetails)
            }
        }
        
    }

}

extension DetailRestaurantUserViewController: UITableViewDelegate {
    
}

extension DetailRestaurantUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(listDish[section].nameDish)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        listDish.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listDishDetail[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? ListDishTableViewCell else { return ListDishTableViewCell() }
        cell.setUpCell(infoDish: listDishDetail[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
