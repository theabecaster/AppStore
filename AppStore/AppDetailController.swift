//
//  AppDetailController.swift
//  AppStore
//
//  Created by Abraham Gonzalez on 11/13/18.
//  Copyright © 2018 Abraham Gonzalez. All rights reserved.
//

import UIKit

class AppDetailController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var app: App?{
        didSet{
            
            if app?.Screenshots != nil{
                return
            }
            
            guard let id = app?.Id else {return}
            let jsonUrlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
            guard let url = URL(string: jsonUrlString) else {return}
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let data = data else {return}
                
                do{
                    let appDetail = try JSONDecoder().decode(App.self, from: data)
                    
                    // By setting the app again the didSet method above is infinitely triggered
                    self.app = appDetail
                    DispatchQueue.main.async(execute: {
                        self.collectionView.reloadData()
                    })
                    
                } catch let jsonError{
                    print("Error while parsing JSON ", jsonError)
                }
                }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        collectionView.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderId")
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: "DescriptionCellId")
        collectionView.register(AppInfoCell.self, forCellWithReuseIdentifier: "AppInfoCellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfCells = 0
        if let screenShots = app?.Screenshots{
            numberOfCells += 1
        }
        if let description = app?.description{
            numberOfCells += 1
        }
        if let count = app?.appInformation?.count{
            numberOfCells += 1
        }
        return numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! ScreenshotCell
            cell.app = app
            return cell
        }
        if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionCellId", for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppInfoCellId", for: indexPath) as! AppInfoCell
        cell.appInfo = app?.appInformation
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1{
            let size = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: size, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 30)
        }
        
        if indexPath.item == 2{
            if let count = app?.appInformation?.count{
                let cellHeight = CGFloat(integerLiteral: count * 20)
                return CGSize(width: view.frame.width, height: cellHeight + 50)
            }
        }
        
        return CGSize(width: view.frame.width, height: 150)
    }
    
    func descriptionAttributedText() -> NSAttributedString{
        let description = NSMutableAttributedString(string: "Description\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        if let descript = app?.description{
            description.append(NSAttributedString(string: descript, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        }
        return description
    }
    
}

class AppDetailDescriptionCell: BaseCell{
    override func setupViews() {
        super.setupViews()
        
        addSubview(textView)
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample"
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
}

class AppDetailHeader: BaseCell{
    
    var app: App?{
        didSet{
            guard let imageName = app?.ImageName else {return}
            imageView.image = UIImage(named: imageName)
            
            if let appName = app?.Name{
            nameLabel.text = appName
            }
            
            if let price = app?.Price{
                buyButton.setTitle("$\(price)", for: .normal)
            }
            else{
                buyButton.setTitle("GET", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .gray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Frozen"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-10-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]-14-[v1]", views: imageView, segmentedControl)
        addConstraintsWithFormat(format: "V:|-25-[v0]", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "H:[v0(55)]-14-|", views: buyButton)
        addConstraintsWithFormat(format: "V:|-86-[v0]", views: buyButton)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:|-170-[v1(0.5)]", views: segmentedControl, dividerLineView)
    }
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
         addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class BaseCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){}
}
