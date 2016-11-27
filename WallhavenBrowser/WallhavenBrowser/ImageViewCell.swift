//
//  ImageViewCell.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let cellId = "ImageViewCell"
    @IBOutlet weak var imageView: CustomImageView!
    
    //MARK: Functions
    
    func setImage(url: String, firstTime: inout Bool) {
        let isFirstTime = firstTime
        firstTime = false
        
        imageView.imagePath = url
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: url), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cacheType, url) in
            
            if (isFirstTime) {
                self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
            
            if let err = error {
                print("\(err.description)")
            } else {
                if (isFirstTime) {
                    UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: {
                        self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                        }, completion: nil)
                    
                    UIView.animate(withDuration: 0.5, delay: 0.15, options: [], animations: {
                        self.imageView.alpha = 1
                        }, completion: nil)
                } else {
                    self.imageView.alpha = 1
                    self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1);
                }
            }
            
        }
    }
}
