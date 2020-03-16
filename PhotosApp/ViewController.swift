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
    let leftbarbutton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoOrFolder))
    var urlArray:[URL] = []
    var previousUrlArrays:[URL] = []
//    ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/monarch.png","https://homepages.cae.wisc.edu/~ece533/images/sails.png","https://homepages.cae.wisc.edu/~ece533/images/tulips.png","https://homepages.cae.wisc.edu/~ece533/images/watch.png","https://homepages.cae.wisc.edu/~ece533/images/serrano.png","https://homepages.cae.wisc.edu/~ece533/images/fruits.png","https://homepages.cae.wisc.edu/~ece533/images/goldhill.png","https://homepages.cae.wisc.edu/~ece533/images/lena.png","https://homepages.cae.wisc.edu/~ece533/images/pool.png"]
//
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            urlArray = fileURLs
           
            
        } catch {
            print("Error while enumeration")
        }
        
        self.navigationItem.title = "Photos"
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
        if cell.isPhoto{
            if let image  = cell.imageView.image {
                
                let vc = DetailViewController(image: image)
                
                let navVc = UINavigationController(rootViewController: vc)
                
                self.present(navVc, animated: true, completion: nil)
            }
        }else{
            previousUrlArrays = urlArray
            let fileManager = FileManager.default
            let documentsURL = urlArray[indexPath.row]
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                urlArray = fileURLs
                
                
            } catch {
                print("Error while enumeration")
            }
            
             self.collectionView?.reloadData()
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = leftbarbutton
            
        }
    }
}

extension ViewController{
    
    @objc func addPhotoOrFolder(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let addFolder = UIAlertAction(title: "add Folder", style: .default) { (_) in
            actionSheet.dismiss(animated: true) {
                self.getFolderInput()
            }
        }

        actionSheet.addAction(addFolder)
        
            self.present(actionSheet, animated: true, completion: nil)
   
    }
    
    func getFolderInput(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter folder name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textFieldText = alert?.textFields?[0].text else{return}
            self.createFolder(folderName:textFieldText)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createFolder(folderName:String){
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath =  documentDirectory.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error while creating")
            }
        }
    }
}
