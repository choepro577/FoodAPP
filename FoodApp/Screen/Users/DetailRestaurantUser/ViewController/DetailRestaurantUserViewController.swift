//
//  DetailRestaurantUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/24/20.
//

import UIKit
import Kingfisher

class DetailRestaurantUserViewController: UIViewController {
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var dishtextLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var countDishLabel: UILabel!
    @IBOutlet weak var dismissImageView: UIImageView!
    @IBOutlet weak var lishDishTableView: UITableView!
    
    var listDish: [InfoDish] = [InfoDish]()
    var infoRestaurant: InfoRestaurant?
    var listDishDetail: [[InfoDishDetail]] = [[InfoDishDetail]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInfoCard()
        getListDish()
        setUpAction()
        setUpTableView()
    }
    
    func getInfoCard() {
        guard let infoRestaurant = infoRestaurant  else { return }
        FirebaseManager.shared.getInfoCard(uidRestaurant: infoRestaurant.uid) { (countDish, totalPrice, listInfoCart) in
            
            if countDish == 0 {
                DispatchQueue.main.async {
                    self.countDishLabel.text = ""
                    self.totalPriceLabel.text = ""
                }
            } else {
                DispatchQueue.main.async {
                    self.countDishLabel.text = "\(countDish)"
                    self.totalPriceLabel.text = "\(totalPrice)"
                }
            }
        }
    }
    
    func setUpAction() {
        let imageDismissRestaurantGesture = UITapGestureRecognizer(target: self, action:  #selector(self.dismissAction))
        dismissImageView.isUserInteractionEnabled = true
        self.dismissImageView.addGestureRecognizer(imageDismissRestaurantGesture)
        
        let cartGesture = UITapGestureRecognizer(target: self, action:  #selector(self.cartAction))
        self.cartView.addGestureRecognizer(cartGesture)
    }
    
    @objc func dismissAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cartAction(sender : UITapGestureRecognizer) {
        let vc = CartViewController()
        vc.infoRestaurant = infoRestaurant
        self.navigationController?.pushViewController(vc, animated: true)
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
            header.backgroundColor = .systemGray6
            let imageView = UIImageView(image: UIImage(named: "comtam"))
            let resource = ImageResource(downloadURL: URL(string: infoRestaurant?.imageLink ?? "")!, cacheKey: infoRestaurant?.imageLink)
            imageView.kf.setImage(with: resource)
            imageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 220)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let infoRestaurantView = UIView(frame: CGRect(x: imageView.frame.size.width/2 - 300/2, y: imageView.frame.size.height/2, width: 300, height: 130))
            infoRestaurantView.backgroundColor = .white
            infoRestaurantView.layer.cornerRadius = infoRestaurantView.frame.height/5
            infoRestaurantView.layer.shadowRadius = 5
            infoRestaurantView.layer.shadowColor = UIColor.black.cgColor
            infoRestaurantView.layer.shadowOpacity = 0.5
            
            if let infoRestaurant = infoRestaurant {
                let label = UILabel(frame: CGRect(x: 10, y: 0, width: 280, height: 80))
                label.text = "\(infoRestaurant.name)"
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 22, weight: .bold)
                label.numberOfLines = 0
                
                let titleLabel = UILabel(frame: CGRect(x: 10, y: 80, width: 280, height: 20))
                titleLabel.text = "\(infoRestaurant.title)"
                titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
                titleLabel.textColor = .systemGray
                titleLabel.textAlignment = .center
                titleLabel.numberOfLines = 0
                
                let addressLabel = UILabel(frame: CGRect(x: 10, y: 100, width: 280, height: 20))
                addressLabel.text = "\(infoRestaurant.address)"
                addressLabel.font = .systemFont(ofSize: 15, weight: .bold)
                addressLabel.textColor = .systemGray
                addressLabel.textAlignment = .center
                addressLabel.numberOfLines = 0
                
                let dishLabel = UILabel(frame: CGRect(x: 20, y: 240, width: 280, height: 20))
                dishLabel.text = "\(listDish[section].nameDish)"
                dishLabel.font = .systemFont(ofSize: 18, weight: .bold)
                dishLabel.numberOfLines = 0
                
                header.addSubview(imageView)
                header.addSubview(infoRestaurantView)
                header.addSubview(dishLabel)
                infoRestaurantView.addSubview(label)
                infoRestaurantView.addSubview(titleLabel)
                infoRestaurantView.addSubview(addressLabel)
                return header
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(listDish[section].nameDish)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 270
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddToCardViewController()
        vc.infoRestaurant = infoRestaurant
        vc.dishDetail = listDishDetail[indexPath.section][indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


