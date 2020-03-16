//
//  PhotoCell.swift
//  PhotosApp
//
//  Created by Karan Karthic on 16/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class PhotoCell:UICollectionViewCell
{
    
    lazy var imageView = AsyncImageView(frame: self.contentView.frame)
    var isPhoto = true
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        isPhoto = imageView.isPhoto
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AsyncImageView:UIImageView {
    
    var isPhoto = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func loadImageWithURl(url:URL){
        
        let sourceURL = url.lastPathComponent
        
        if sourceURL.hasSuffix(".png") == false,sourceURL.hasSuffix(".jpg") == false{
            DispatchQueue.main.async {
                
                self.image = UIImage(named: "folder")
                
            }
            isPhoto = false
            return
        }
 
        if let image = getImageFromCache(fileUrl: sourceURL){
            DispatchQueue.main.async {
                
                self.image = image
                
            }
            
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
                
                self.storeToDB(sourceUrl: sourceURL, data: data)
                
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


