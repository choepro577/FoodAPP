//
//  DetailHistoryViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/4/20.
//

import UIKit

class DetailHistoryViewController: UIViewController {

    @IBOutlet weak var detailHistoryTableView: UITableView!
    
    @IBOutlet weak var backImageView: UIImageView!
    var listInfoDistOrder: [InfoCard] = [InfoCard]()
    var historyOrder: HistoryOrderofUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getInfoCart()
        setUpAction()
    }
    
    func getInfoCart() {
        guard let historyOrder = historyOrder else { return }
        print(historyOrder)
        FirebaseManager.shared.getInfoInRestaurantCard(uidUser: historyOrder.id) { (countDish, totalPrice, listInfocart) in
            self.listInfoDistOrder = listInfocart
            DispatchQueue.main.async {
                self.detailHistoryTableView.reloadData()
            }
        }
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        backImageView.isUserInteractionEnabled = true
        self.backImageView.addGestureRecognizer(gesture)
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

    func setUpTableView() {
        self.detailHistoryTableView.delegate = self
        self.detailHistoryTableView.dataSource = self
        self.detailHistoryTableView.register(UINib(nibName: "DetailHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
   
}

extension DetailHistoryViewController: UITableViewDelegate {
    
}

extension DetailHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listInfoDistOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? DetailHistoryTableViewCell else { return DetailHistoryTableViewCell() }
        cell.setUpCell(infoCard: listInfoDistOrder[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
