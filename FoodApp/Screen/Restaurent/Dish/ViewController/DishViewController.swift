//
//  DishViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/7/20.
//

import UIKit

class DishViewController: UIViewController {

    @IBOutlet weak var dishsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDishTableViewCell()
    }
    
    func setUpDishTableViewCell() {
        dishsTableView.delegate = self
        dishsTableView.dataSource = self
        dishsTableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    @IBAction func addDishActionButton(_ sender: Any) {
        let vc = AddDishsViewController()
        self.present(vc, animated: true)
    }
    
}

extension DishViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StatusDishViewController()
        self.present(vc, animated: true)
    }
    
}

extension DishViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? DishTableViewCell else { return DishTableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
