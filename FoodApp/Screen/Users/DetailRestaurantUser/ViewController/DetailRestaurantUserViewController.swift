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
        FirebaseManager.shared.getListDishRestaurantForUser(uid: uid) { (listDish, listDishDetail) in
            self.listDish = listDish
            self.listDishDetail = listDishDetail
            DispatchQueue.main.async {
                self.lishDishTableView.reloadData()
            }
        }
    }
    
}

extension DetailRestaurantUserViewController: UITableViewDelegate {
    
}

extension DetailRestaurantUserViewController: UITableViewDataSource {
    
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 250))
            header.backgroundColor = .systemGray2
            let imageView = UIImageView(image: UIImage(named: "comtam"))
            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let infoRestaurantView = UIView(frame: CGRect(x: imageView.frame.size.width/2 - 150/2, y: imageView.frame.size.height/1.5, width: 150, height: 100))
            infoRestaurantView.backgroundColor = .white
            //imageView.addSubview(infoRestaurantView)
            header.addSubview(imageView)
            header.addSubview(infoRestaurantView)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(listDish[section].nameDish)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 250
        }
        return 30
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
