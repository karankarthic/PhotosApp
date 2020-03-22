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
    let leftbarbutton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backToParentDirectory))
    var lastpathcomponent = ""
    var latestPathURl:URL? = nil
    let fileManager = FileManager.default
    var urlArray:[URL] = []
//    ["https://homepages.cae.wisc.edu/~ece533/images/airplane.png","https://homepages.cae.wisc.edu/~ece533/images/arctichare.png","https://homepages.cae.wisc.edu/~ece533/images/baboon.png","https://homepages.cae.wisc.edu/~ece533/images/monarch.png","https://homepages.cae.wisc.edu/~ece533/images/sails.png","https://homepages.cae.wisc.edu/~ece533/images/tulips.png","https://homepages.cae.wisc.edu/~ece533/images/watch.png","https://homepages.cae.wisc.edu/~ece533/images/serrano.png","https://homepages.cae.wisc.edu/~ece533/images/fruits.png","https://homepages.cae.wisc.edu/~ece533/images/goldhill.png","https://homepages.cae.wisc.edu/~ece533/images/lena.png","https://homepages.cae.wisc.edu/~ece533/images/pool.png"]
//
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            urlArray = fileURLs
           
            
        } catch {
            print("Error while enumeration")
        }
        latestPathURl = documentsURL
        self.navigationItem.title = "Photos"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoOrFolder))
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 20, left: 30, bottom: 5, right: 30)
        flowLayout.itemSize = .init(width: 155, height: 150)
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView?.register(FolderCell.self, forCellWithReuseIdentifier: "FolderCell")
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
        let url = self.urlArray[indexPath.row]
        if url.pathExtension != "" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            cell.backgroundColor = UIColor.gray
            cell.imageView.loadImageWithURl(url: url)
            cell.layer.cornerRadius = 10
            return cell
        }
        else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCell
            cell.backgroundColor = UIColor.gray
            cell.nameOfFolderView.text = url.lastPathComponent
            cell.layer.cornerRadius = 10
            return cell
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell
        {
            if let image  = cell.imageView.image {
                
                let vc = DetailViewController(image: image)
                
                let navVc = UINavigationController(rootViewController: vc)
                
                self.present(navVc, animated: true, completion: nil)
            }
        }
       else{
        
            let documentsURL = urlArray[indexPath.row]
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                urlArray = fileURLs
                latestPathURl = documentsURL
                
                
            } catch {
                print("Error while enumeration")
            }
            
             self.collectionView?.reloadData()

            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backToParentDirectory))
            
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
        
        let addfile = UIAlertAction(title: "add Image", style: .default) { (_) in
            actionSheet.dismiss(animated: true) {
               let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true)
            }
        }

        let cancel = UIAlertAction(title: "cancel", style: .cancel) { (_) in
            
        }
        
        actionSheet.addAction(addFolder)
        actionSheet.addAction(addfile)
        actionSheet.addAction(cancel)
        
            self.present(actionSheet, animated: true, completion: nil)
   
    }
    
    func getFolderInput(){
        let alert = UIAlertController(title: nil, message: "Name Of Folder", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "enter folder name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let textFieldText = alert?.textFields?[0].text else{return}
            self.createFolder(folderName:textFieldText)
            guard let url = self.latestPathURl else{return}
            self.reloadData(url: url, isToSetLatestPath: false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createFolder(folderName:String){
        
        if let url = latestPathURl {
            let filePath =  url.appendingPathComponent(folderName)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error while creating")
                }
            }
            return
        }

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
    
    @objc func backToParentDirectory(){
        
        guard let tempUrlString = latestPathURl?.absoluteString else {return}
        let temp = tempUrlString.components(separatedBy: "/")
        var urlString = ""
        
        for (index,component) in temp.enumerated()
        {
            if index == ((temp.count - 1) - 1)
            {
                break
            }
            urlString.append(component)
            urlString.append("/")
        }
        
        guard let url = URL.init(string: urlString) else{return}
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        reloadData(url: url, isToSetLatestPath: true)

        if url == documentsURL{
            self.navigationItem.leftBarButtonItem = nil
            
            latestPathURl = nil
        }
        
    }
    
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let url = info[.imageURL] as? URL else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let fileName = url.lastPathComponent
         guard let pathUrl = latestPathURl else { return }
        
          let filePath =  pathUrl.appendingPathComponent(fileName)
        
       
        do {
            try imageData.write(to: filePath, options: .atomic)
        } catch {
            print("Error while creating")
        }
    
         dismiss(animated: true)
        
        reloadData(url: pathUrl, isToSetLatestPath: false)
        
    }
    
    
    func reloadData(url:URL,isToSetLatestPath:Bool)
    {
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            urlArray = fileURLs
            
            if isToSetLatestPath {
                
                 latestPathURl = url
                
            }
            
        } catch {
            print("Error while enumeration")
        }
        
        self.collectionView?.reloadData()
        
        
    }
    
}
