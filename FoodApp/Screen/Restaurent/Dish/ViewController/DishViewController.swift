//
//  DishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit
import Kingfisher

class DishViewController: UIViewController {

    @IBOutlet weak var catagoryImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var nameCatagoryView: UIView!
    @IBOutlet weak var nameDishLabel: UILabel!
    @IBOutlet weak var dishsTableView: UITableView!
    
    var listDishDetails: [InfoDishDetail] = [InfoDishDetail]()
    var imageLink: String?
    var nameDish: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDishTableView()
        setUpUI()
        getlistDishDetails()
    }
    
   
    func setUpDishTableView() {
        dishsTableView.delegate = self
        dishsTableView.dataSource = self
        dishsTableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func getlistDishDetails() {
        guard let nameDish = nameDish else { return }
        FirebaseManager.shared.getListDishDetails(nameDish: nameDish){ (listDishDetailResult) in
            self.listDishDetails = listDishDetailResult
            print(self.listDishDetails)
            DispatchQueue.main.async {
                self.dishsTableView.reloadData()
            }
        }
    }
    
    func setUpUI() {
        guard let imageLink = imageLink else { return }
        let resource = ImageResource(downloadURL: URL(string: imageLink)!, cacheKey: imageLink)
        catagoryImageView.kf.setImage(with: resource)
        nameDishLabel.text = nameDish
        nameCatagoryView.layer.cornerRadius = nameCatagoryView.frame.width/20
        nameCatagoryView.layer.shadowRadius = 5
        nameCatagoryView.layer.shadowColor = UIColor.black.cgColor
        nameCatagoryView.layer.shadowOffset = CGSize (width: 10, height: 10)
        nameCatagoryView.layer.shadowOpacity = 0.1
        nameCatagoryView.layer.borderWidth = 2
        nameCatagoryView.layer.borderColor = UIColor.white.cgColor
        
        addButton.layer.cornerRadius = addButton.frame.width/5
        addButton.layer.shadowRadius = 5
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize (width: 10, height: 10)
        addButton.layer.shadowOpacity = 0.1
        addButton.layer.borderWidth = 2
        addButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func addDishActionButton(_ sender: Any) {
        let vc = AddDishsViewController()
        vc.nameImageCatagory = nameDish
        self.present(vc, animated: true)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

extension DishViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let nameDish = nameDish else { return }
            FirebaseManager.shared.deleteDish(nameDish: nameDish, nameDetailDish: listDishDetails[indexPath.row].nameDishDetail) { (success, error) in
                if (success) {
                    self.showAlert("Notification", "Deleted")
                } else {
                    return
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StatusDishViewController()
        vc.nameDish = nameDish
        vc.nameDishDetail = listDishDetails[indexPath.row].nameDishDetail
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension DishViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDishDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? DishTableViewCell else { return DishTableViewCell() }
        cell.setUpCell(infoDishDetail: listDishDetails[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
