//
//  CategoryCell.swift
//  AppStore
//
//  Created by Abraham Gonzalez on 11/11/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var featuredAppsController: FeaturedAppsController?
    
    var category: Category?{
        didSet{
            guard let category = category else {return}
            nameLabel.text = category.name
            appsCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        appsCollectionView.clipsToBounds = false
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: "AppCellId")
        
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))

        nameLabel.frame = CGRect(x: 13, y: 5, width: frame.width, height: 20)
        dividerLineView.frame = CGRect(x: 10, y: frame.height + 25, width: frame.width, height: 1)
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = appsCollectionView.dequeueReusableCell(withReuseIdentifier: "AppCellId", for: indexPath) as! AppCell
        cell.app = category?.apps?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let category = category else {return 0}
        guard let apps = category.apps else {return 0}
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = category?.apps?[indexPath.item]{
            featuredAppsController?.showAppDetails(app: app)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LargeCategoryCell: CategoryCell{
    override   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 25)
    }
}


class Header: CategoryCell{
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height)
    }
    
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = appsCollectionView.dequeueReusableCell(withReuseIdentifier: "AppCellId", for: indexPath) as! AppCell
        cell.app = category?.apps?[indexPath.item]
        cell.imageView.layer.cornerRadius = 8
        return cell
    }

}

class AppCell: UICollectionViewCell{
    
    var app: App?{
        didSet{
            guard let app = app else {return}
            nameLabel.text = app.Name
            
            if nameLabel.text == "" {
                nameLabel.text = ""
                categoryLabel.text = ""
                priceLabel.text = ""
            }
            
            if let length = nameLabel.text?.count{
            if length > 12{
                categoryLabel.frame = CGRect(x: 5, y: frame.width + 54, width: frame.width, height: 20)
                priceLabel.frame = CGRect(x: 5, y: frame.width + 72, width: frame.width, height: 20)
            }
            else{
                categoryLabel.frame = CGRect(x: 5, y: frame.width + 44, width: frame.width, height: 20)
                priceLabel.frame = CGRect(x: 5, y: frame.width + 62, width: frame.width, height: 20)
            }
            }
            
            categoryLabel.text = app.Category
            if let name = app.ImageName{
            imageView.image = UIImage(named: name)
            }
            
            if let price = app.Price{
                priceLabel.text = "$\(price)"
            }
            else{
                priceLabel.text = ""
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 0, y: 15, width: Int(frame.width), height: 100)
        
        /*      the collectionView property clipsToBounds must be set to false for this to work -> placing an item outside the cell with CGRect
        */
        nameLabel.frame = CGRect(x: 5, y: frame.width + 16, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 5, y: frame.width + 54, width: frame.width, height: 20)
        priceLabel.frame = CGRect(x: 5, y: frame.width + 72, width: frame.width, height: 20)
    }
    
    
    let imageView: UIImageView = {
        let image = UIImage(named: "frozen")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney Build It: Frozen"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$3.99"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
}
