//
//  ViewController.swift
//  AppStore
//
//  Created by Abraham Gonzalez on 11/11/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories: [Category]?
    var bannerCategory: BannerCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Featured Apps"
    
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCellId")
        collectionView.register(LargeCategoryCell.self, forCellWithReuseIdentifier: "LargeCategoryCellId")
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderId")
        
        Category.fetchFeaturedApps { (categories, bannerCategory) in
            self.categories = categories
            self.bannerCategory = bannerCategory
            self.collectionView.reloadData()
        }
    }

    
    func showAppDetails(app: App){
        let layout = UICollectionViewFlowLayout()
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        appDetailController.app = app
        self.navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = categories else {return 0}
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LargeCategoryCellId", for: indexPath) as! LargeCategoryCell
            cell.category = categories?[indexPath.item]
            cell.featuredAppsController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellId", for: indexPath) as! CategoryCell
        cell.category = categories?[indexPath.item]
        cell.featuredAppsController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2{
            return CGSize(width: view.frame.width, height: 130)
        }
        return  CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: indexPath) as! Header
        let category = Category()
        category.apps = bannerCategory?.apps
        
        header.category = category
        header.dividerLineView.isHidden = true
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    
}

