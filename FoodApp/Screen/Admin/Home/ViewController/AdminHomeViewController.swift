//
//  AdminHomeViewController.swift
//  FoodApp
//
//  Created by Nguyễn Đức Hiếu on 11/4/20.
//

import UIKit

class AdminHomeViewController: UIViewController {
   
    @IBOutlet weak var typeRestaurentCollectionView: UICollectionView!
    let typeRestaurentImage: [String] = ["ricerestaurant","milktea","noodles","friedchicken","healthy","snacks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTypeRestaurentCollectionView()
        self.title = "Hi Sir !"
    }
    
    func setUpTypeRestaurentCollectionView() {
        typeRestaurentCollectionView.delegate = self
        typeRestaurentCollectionView.dataSource = self
        typeRestaurentCollectionView.register(UINib(nibName: "TypeRestaurentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CellID")
    }

}

extension AdminHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListRestaurentViewController()
        vc.typeRestaurant = typeRestaurentImage[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AdminHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        typeRestaurentImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as? TypeRestaurentCollectionViewCell else { return TypeRestaurentCollectionViewCell() }
        cell.setUpCell(nameImage:typeRestaurentImage[indexPath.row] )
        return cell
    }
}

extension AdminHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceItem: CGFloat = 7
        let numberCellForRow: CGFloat = 3
        let widthForOneItem = (self.typeRestaurentCollectionView.bounds.size.width - (spaceItem * (numberCellForRow + 1))) / numberCellForRow
        return CGSize (width: widthForOneItem, height: widthForOneItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15 // khoảng cách giữa các hàng với nhau
    }
}
