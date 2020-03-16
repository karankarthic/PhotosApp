//
//  DetailViewController.swift
//  PhotosApp
//
//  Created by Karan Karthic on 16/03/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class DetailViewController:UIViewController
{
    lazy var imageView = UIImageView()

    init(image:UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        
        self.view.addSubview(imageView)
        
        self.view.backgroundColor = .black
        let width = self.view.bounds.width
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                     imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                     imageView.widthAnchor.constraint(equalToConstant:width ),
                                     imageView.widthAnchor.constraint(equalToConstant:width )])
        
        
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
