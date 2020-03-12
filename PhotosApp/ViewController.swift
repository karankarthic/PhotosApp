//
//  ViewController.swift
//  PhotosApp
//
//  Created by Karan Karthic on 12/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
   
    var collectionView : UICollectionView? = nil
    
    let urlArray:[String] = ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/monarch.png","https://homepages.cae.wisc.edu/~ece533/images/sails.png","https://homepages.cae.wisc.edu/~ece533/images/tulips.png","https://homepages.cae.wisc.edu/~ece533/images/watch.png","https://homepages.cae.wisc.edu/~ece533/images/watch.png","https://homepages.cae.wisc.edu/~ece533/images/serrano.png","https://homepages.cae.wisc.edu/~ece533/images/fruits.png","https://homepages.cae.wisc.edu/~ece533/images/goldhill.png","https://homepages.cae.wisc.edu/~ece533/images/lena.png","https://homepages.cae.wisc.edu/~ece533/images/pool.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 20, left: 30, bottom: 5, right: 30)
        flowLayout.itemSize = .init(width: 155, height: 150)
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView?.backgroundColor = UIColor.cyan
        
        self.view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.urlArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! PhotoCell
        cell.backgroundColor = UIColor.green
        guard let url = URL.init(string: self.urlArray[indexPath.row]),let data = try? Data(contentsOf: url) else {
                return UICollectionViewCell()
        }
        DispatchQueue.main.async {
            cell.imageView.image = UIImage(data: data)
        }
        
        cell.layer.cornerRadius = 10
        return cell
    }

}

class PhotoCell:UICollectionViewCell
{
    
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(imageView)
        imageView.frame = self.contentView.frame
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

