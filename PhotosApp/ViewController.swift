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
    
    let urlArray:[String] = ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/monarch.png","https://homepages.cae.wisc.edu/~ece533/images/sails.png","https://homepages.cae.wisc.edu/~ece533/images/tulips.png","https://homepages.cae.wisc.edu/~ece533/images/watch.png","https://homepages.cae.wisc.edu/~ece533/images/serrano.png","https://homepages.cae.wisc.edu/~ece533/images/fruits.png","https://homepages.cae.wisc.edu/~ece533/images/goldhill.png","https://homepages.cae.wisc.edu/~ece533/images/lena.png","https://homepages.cae.wisc.edu/~ece533/images/pool.png"]
    
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
        collectionView?.backgroundColor = UIColor.black
        
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
        cell.backgroundColor = UIColor.gray
        cell.imageView.loadImageWithURl(url: self.urlArray[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    
}

class PhotoCell:UICollectionViewCell
{
    
    lazy var imageView = AsyncImageView(frame: self.contentView.frame)
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AsyncImageView:UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func loadImageWithURl(url:String){
        
        let sourceURL = url.components(separatedBy: "https://homepages.cae.wisc.edu/~ece533/images/")
        
        
        if let image = getImageFromCache(fileUrl: sourceURL[1]){
            DispatchQueue.main.async {
                
                self.image = image
                
            }
            
            return
        }
        
        DispatchQueue.global().async {
            if let url = URL.init(string: url),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
                
                self.storeToDB(sourceUrl: sourceURL[1], data: data)
                
                DispatchQueue.main.async {
                    
                    self.image = image
                    
                }
            }else{
                DispatchQueue.main.async {

                    self.image = UIImage.init(named: "default")
                    
                }
                
            }
        }
        
    }
    
    func storeToDB(sourceUrl:String,data:Data){
        
        let fileManager = FileManager.default
        var path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        path.appendPathComponent("\(sourceUrl)")
        fileManager.createFile(atPath:path.path , contents: nil, attributes: .none)
        
        do {
            try data.write(to: path, options: .atomic)
            print("hi download")
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func getImageFromCache(fileUrl:String) -> UIImage?{
        
        let fileManager = FileManager.default
        var path = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        path.appendPathComponent("\(fileUrl)")
        
        if let data = try? Data(contentsOf: path),let image = UIImage(data: data){
            
            return image
            
        }
        
        return nil
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

