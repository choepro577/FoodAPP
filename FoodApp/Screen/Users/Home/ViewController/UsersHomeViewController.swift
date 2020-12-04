//
//  UsersHomeViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/9/20.
//

import UIKit

class UsersHomeViewController: UIViewController {
    
    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var countDishLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var infomationImageView: UIImageView!
    @IBOutlet weak var typeRestaurentColectionViewCell: UICollectionView!
    
    var infoRestaurant: InfoRestaurant?
    let typeRestaurentImage: [String] = ["ricerestaurant","milktea","noodles","friedchicken","healthy","snacks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpColectionViewCell()
        getInfoUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setUpColectionViewCell() {
        typeRestaurentColectionViewCell.delegate = self
        typeRestaurentColectionViewCell.dataSource = self
        typeRestaurentColectionViewCell.register(UINib(nibName: "typeRestaurentUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellID")
    }
    
    func getInfoUser() {
        FirebaseManager.shared.getInfoUser() {(infoUser) in
            if infoUser.address == "" {
                DispatchQueue.main.async {
                    self.addressLabel.text = "Please choose address !"
                }
            } else {
                DispatchQueue.main.async {
                    self.addressLabel.text = infoUser.address
                }
            }
        }
    }
    
    func setUpUI() {
        self.navigationController?.isNavigationBarHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.searchAction))
        self.searchView.addGestureRecognizer(gesture)
        
        let addressViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.searchAddressAction))
        self.addressView.addGestureRecognizer(addressViewGesture)
        
        let infoUsergesture = UITapGestureRecognizer(target: self, action:  #selector(self.watchInfomationUserAction))
        infomationImageView.isUserInteractionEnabled = true
        self.infomationImageView.addGestureRecognizer(infoUsergesture)
        
        let cartgesture = UITapGestureRecognizer(target: self, action:  #selector(self.cartAction))
        cartImageView.isUserInteractionEnabled = true
        self.cartImageView.addGestureRecognizer(cartgesture)
    }
    
    @objc func cartAction(sender : UITapGestureRecognizer) {
        let vc = CartViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchAddressAction(sender : UITapGestureRecognizer) {
        let vc = MapViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchAction(sender : UITapGestureRecognizer) {
        let vc = FindRestaurentDishViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func watchInfomationUserAction(sender : UITapGestureRecognizer) {
        let vc = InfomationUserViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UsersHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListRestaurentUserViewController()
        vc.typeRestaurant = typeRestaurentImage[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UsersHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        typeRestaurentImage.count
    }   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? typeRestaurentUserCollectionViewCell else { return typeRestaurentUserCollectionViewCell() }
        cell.setUpCell(nameImage:typeRestaurentImage[indexPath.row] )
        return cell
    }
}

extension UsersHomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceItem: CGFloat = 7
        let numberCellForRow: CGFloat = 3
        let widthForOneItem = (self.typeRestaurentColectionViewCell.bounds.size.width - (spaceItem * (numberCellForRow + 1))) / numberCellForRow
        return CGSize (width: widthForOneItem, height: widthForOneItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // khoảng cách giữa các hàng với nhau
    }
}

extension UsersHomeViewController: CartViewControllerDelegate {
    func getCount(count: String) {
        countDishLabel.text = count
    }
}

