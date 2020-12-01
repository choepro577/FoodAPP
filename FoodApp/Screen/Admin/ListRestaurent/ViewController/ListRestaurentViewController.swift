//
//  ListRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit
import Kingfisher

class ListRestaurentViewController: UIViewController {

    @IBOutlet weak var restaurentSearchBar: UISearchBar!
    @IBOutlet weak var listRestaurentTableView: UITableView!
    
    var typeRestaurant: String?
    var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadRestaurants()
        setUpRestaurentTableView()
        setUpUI()
    }
    
    func setUpUI() {
        guard let typeRestaurant = typeRestaurant else { return }
        self.title = typeRestaurant
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func LoadRestaurants() {
        guard let typeRestaurant = typeRestaurant else { return }
        FirebaseManager.shared.getListRestaunt(typeRestaurant: typeRestaurant) { (infoRestaurant) in
            self.listRestaurant = infoRestaurant
            DispatchQueue.main.async {
                self.listRestaurentTableView.reloadData()
            }
        }
    }
    
    func setUpRestaurentTableView() {
        listRestaurentTableView.delegate = self
        listRestaurentTableView.dataSource = self
        listRestaurentTableView.register(UINib(nibName: "ListRestaurentTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
}

extension ListRestaurentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsRestaurentViewController()
        vc.typeRestaurant = typeRestaurant
        vc.infoRestaurant = listRestaurant[indexPath.row]
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let typeRestaurant = typeRestaurant else { return }
            FirebaseManager.shared.deleteRestaurant(typeRestaurant: typeRestaurant, uid: listRestaurant[indexPath.row].uid) { (success, error) in
                if (success) {
                    self.showAlert("Notification", "Deleted")
                } else {
                    return
                }
            }
        }
    }
    
}

extension ListRestaurentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listRestaurant.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? ListRestaurentTableViewCell else { return ListRestaurentTableViewCell() }
        cell.setUpInfoCell(infoRestaurant: listRestaurant[indexPath.row])
        let resource = ImageResource(downloadURL: URL(string: listRestaurant[indexPath.row].imageLink)!, cacheKey: listRestaurant[indexPath.row].imageLink)
        cell.imageRestaurant.kf.setImage(with: resource)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
