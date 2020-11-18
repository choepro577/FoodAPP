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
    
    var listRestaurant: [InfoRestaurant] = [InfoRestaurant]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRestaurentTableView()
        setUpUI()
    }
    
    func LoadRestaurants(typeRestaurant: String) {
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
    
    func setUpUI() {
        let icon = UIImage(systemName: "plus.circle")
        let iconSize = CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30))
        let iconButton = UIButton(frame: iconSize)
        iconButton.setBackgroundImage(icon, for: .normal)
        let barButton = UIBarButtonItem(customView: iconButton)
        iconButton.addTarget(self, action: #selector(addRestaurent), for: .touchUpInside)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func addRestaurent(sender : UITapGestureRecognizer) {
        let vc = PopSaveRestaurentViewController ()
        self.present(vc, animated: true)
    }
}

extension ListRestaurentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsRestaurentViewController()
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
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
        print(listRestaurant)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
