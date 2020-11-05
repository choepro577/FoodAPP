//
//  DetailsRestaurentViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/5/20.
//

import UIKit

class DetailsRestaurentViewController: UIViewController {
    
    @IBOutlet weak var addPromoView: UIView!
    @IBOutlet weak var promosTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPromosTableView()
        setUpUI()
    }
    
    func setUpUI() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.addPromoAction))
        self.addPromoView.addGestureRecognizer(gesture)
    }
    
    @objc func addPromoAction(sender : UITapGestureRecognizer) {
       let vc = PopAddPromoViewController()
        self.present(vc, animated: true)
    }

    func setUpPromosTableView() {
        promosTableview.delegate = self
        promosTableview.dataSource = self
        promosTableview.register(UINib(nibName: "PromosTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }

    @IBAction func editRestaurentActionButton(_ sender: Any) {
        let vc = PopSaveRestaurentViewController ()
        self.present(vc, animated: true)
    }
}

extension DetailsRestaurentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
}

extension DetailsRestaurentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? PromosTableViewCell else { return PromosTableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
