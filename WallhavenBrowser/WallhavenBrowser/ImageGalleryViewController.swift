//
//  FirstViewController.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit
import AVFoundation

class ImageGalleryViewController: UICollectionViewController {
    
    //MARK: Properties
    
    var galleryZoomer = GalleryZoomerManager()
    var pinterestLayout = PinterestLayout()
    var imageExtractor = ImageExtractor()
    var galleryType : GalleryType?
    
    var alreadyRefreshing = false
    var elementCounter = 24
    var counter = 1
    
    let pageSize = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? ImageCellViewLayout {
            layout.delegate = pinterestLayout
        }
        
        galleryType = GalleryType(rawValue: (tabBarController?.selectedIndex)!)!
        
        galleryZoomer.parentViewController = self
        imageExtractor.getImageUrls(galleryType: galleryType!, page: 1, completion: { [unowned self] (photos) in
            DispatchQueue.main.async {
                self.refreshImages(photos)
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = pinterestLayout.dataSource.count
        return count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.cellId, for: indexPath) as! ImageViewCell
        cell.setImage(url: pinterestLayout.dataSource[indexPath.row].path, firstTime: &pinterestLayout.dataSource[indexPath.row].firstTimeShown)
        
        let randomWhite : Float = Float((arc4random() % 40 + 10)) / Float(255.0);
        cell.backgroundColor = UIColor(white: CGFloat(randomWhite), alpha: 1)
        
        galleryZoomer.installOnImageView(cell.imageView)
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if(contentHeight > 0 && !alreadyRefreshing){
            if offsetY > contentHeight - scrollView.frame.size.height {
                
                alreadyRefreshing = true
                counter += 1
                
                imageExtractor.getImageUrls(galleryType: galleryType!, page: counter, completion: { [unowned self] (photos) in
                    DispatchQueue.main.async {
                        
                        self.elementCounter += 1
                        self.refreshImages(photos)
                        
                        if(self.elementCounter % 24 == 0){
                            self.alreadyRefreshing = false
                            self.elementCounter = 0
                        }
                    }
                })
            }
        }
    }
    
    private func refreshImages(_ photos: [Photo]){
        self.pinterestLayout.dataSource = photos
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [IndexPath(item: photos.count-1, section: 0)])
        }, completion: { (succeed) in
            CATransaction.commit()
        })
        self.activityIndicator.stopAnimating()
    }
}
