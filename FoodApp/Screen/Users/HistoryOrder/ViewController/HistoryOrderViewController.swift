//
//  HistoryOrderViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 12/3/20.
//

import UIKit

class HistoryOrderViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var orderTableView: UITableView!
    
    var historyOrder: [HistoryOrderofUser] = [HistoryOrderofUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        setUpTableView()
        getHistoryOrder()
        setUpAction()
    }
    
    func getHistoryOrder() {
        FirebaseManager.shared.getHistoryOrder() { (historyOrder) in
            self.historyOrder = historyOrder
            DispatchQueue.main.async {
                self.orderTableView.reloadData()
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
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        self.orderTableView.register(UINib(nibName: "historyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }

}

extension HistoryOrderViewController: UITableViewDelegate {
    
}

extension HistoryOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? historyOrderTableViewCell else { return historyOrderTableViewCell() }
        cell.setUpCell(infoHistoryOrder: historyOrder[indexPath.row])
        return cell
    }

}
