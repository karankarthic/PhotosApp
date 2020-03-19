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
   // var isPhoto = true
    
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

class FolderCell:UICollectionViewCell
{
    lazy var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "folder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    lazy var nameOfFolderView : UILabel = {
        var nameOfFolderView = UILabel()
        nameOfFolderView.layer.cornerRadius = 10
        nameOfFolderView.textAlignment = .center
        nameOfFolderView.translatesAutoresizingMaskIntoConstraints = false
        return nameOfFolderView
    }()
    //var isPhoto = false
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(nameOfFolderView)
        
        NSLayoutConstraint.activate([ imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                                      imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                      imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        
                                      nameOfFolderView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
                                      nameOfFolderView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                                      nameOfFolderView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                                      nameOfFolderView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
                                      nameOfFolderView.heightAnchor.constraint(equalToConstant: 16)])
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

