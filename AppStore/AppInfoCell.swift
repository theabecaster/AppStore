//
//  AppInfoCell.swift
//  AppStore
//
//  Created by Abraham Gonzalez on 11/15/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class AppInfoCell: BaseCell, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    var appInfo: [AppInfo]?{
        didSet{
            
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appInfo?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! Cell
        cell.leftLabel.text = appInfo?[indexPath.item].Name
        cell.rightLabel.text = appInfo?[indexPath.item].Value
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func setupViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "CellId")
        
        addSubview(informationLabel)
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]", views: informationLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0]", views: informationLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|-28-[v0]|", views: collectionView)
    
    }
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Information"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private class Cell: BaseCell{
        override func setupViews() {
            
            addSubview(leftFrame)
            addSubview(rightFrame)
            addSubview(leftLabel)
            addSubview(rightLabel)
            
            leftFrame.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 8, left: 14, bottom: 0, right: 0), size: CGSize(width: 82, height: frame.height - 8))
            rightFrame.anchor(top: topAnchor, leading: leftFrame.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 0), size: CGSize(width: 220, height: frame.height - 8))
            leftLabel.anchor(top: nil, leading: nil, bottom: leftFrame.bottomAnchor, trailing: leftFrame.trailingAnchor)
            rightLabel.anchor(top: nil, leading: rightFrame.leadingAnchor, bottom: rightFrame.bottomAnchor, trailing: nil)
        }
        
        let leftFrame: UIView = {
            let view = UIView()
            return view
        }()
        
        let rightFrame: UIView = {
            let view = UIView()
            return view
        }()
        
        let rightLabel: UILabel = {
            let label = UILabel()
            label.text = "Right Text"
            label.font = UIFont.systemFont(ofSize: 11)
            return label
        }()
        
        let leftLabel: UILabel = {
            let label = UILabel()
            label.text = "Left Text"
            label.font = UIFont.systemFont(ofSize: 11)
            label.textColor = .lightGray
            return label
        }()
    }
}


extension UIView{
    
    func fillSuperView(){
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView){
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize? = nil){
        
        translatesAutoresizingMaskIntoConstraints = false                                               // Activate auto layout
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true         // bottom and trailing constants must be negative
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true      // bottom and trailing constants must be negative
        }
        
        if let size = size{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
}
