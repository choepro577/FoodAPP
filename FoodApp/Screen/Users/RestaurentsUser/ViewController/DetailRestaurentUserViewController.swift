//
//  DetailRestaurentUserViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/10/20.
//

import UIKit

class DetailRestaurentUserViewController: UIViewController {
    
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var restaurentTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpAction()
    }
    
    func setUpTableView() {
        restaurentTableview.delegate = self
        restaurentTableview.dataSource = self
        restaurentTableview.register(UINib(nibName: "RestaurentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CellID")
    }
    
    func setUpAction() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.backAction))
        closeImageView.isUserInteractionEnabled = true
        self.closeImageView.addGestureRecognizer(gesture)
    }
    
    @objc func backAction(sender : UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DetailRestaurentUserViewController: UITableViewDelegate {
    
}

extension DetailRestaurentUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as? RestaurentsTableViewCell else { return RestaurentsTableViewCell() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

