//
//  GalleryZoomerManager.swift
//  Gallery Zoomer
//
//  Created by Daniel Jankowski on 10/04/2016.
//  Copyright © 2016 Daniel Jankowski. All rights reserved.
//

import Foundation
import Photos
import UIKit
import Toast_Swift

class GalleryZoomerManager: NSObject {
    
    // MARK: Properties
    
    let animationDuration = 0.3
    let animationTransformDuration = 0.2
    
    let scaleUpRatio: CGFloat = 1.2
    let scaleDownRatio: CGFloat = 0.8
    
    let maximumAlphaValue: CGFloat = 1.0
    let minimumAlphaValue: CGFloat = 0.3
    
    var parentViewController: UIViewController?
    
    var imageView: CustomImageView!
    var imageViewStartPosition: CGPoint?
    
    var photoLibrary =  PHPhotoLibrary.shared()
    
    var mediaViewController: MediaViewController!
    
    // MARK: Methods
    
    internal func installOnImageView(_ view: UIImageView) {
        view.isUserInteractionEnabled = true
        addHandleFocusToView(view)
    }
    
    func handleFocus(_ sender: UITapGestureRecognizer) {
        if(parentViewController == nil) {
            print("Illegal argument exception: parent is not initialized.")
            return
        }
        
        imageView = sender.view! as! CustomImageView
        
        initMediaViewController()
        addHandleDefocusToView(mediaViewController.imageView)
        animateScaleUpTransition()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save,
                                         target: self, action: #selector(GalleryZoomerManager.save))
        parentViewController?.navigationItem.rightBarButtonItem = saveButton
    }
    
    func handleDefocus(_ sender: UITapGestureRecognizer) {
        endFocusing()
    }
    
    func endFocusing() {
        animateScaleDownTransition()
        parentViewController?.navigationItem.rightBarButtonItem = nil
    }
    
    func save() {
        print("selected image: \(imageView.imagePath!)")
        
        if(PHPhotoLibrary.authorizationStatus() != .authorized) {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if(status == .authorized) {
                    self.saveImage()
                } else {
                    self.showToast(message: "Application needs permission to access photo library to save wallpaper.")
                }
            })
        } else{
            saveImage()
        }
    }
    
    private func showToast(message : String){
        DispatchQueue.main.async {
            self.parentViewController?.view.makeToast(message, duration: 3, position: .center)
        }
    }
    
    private func saveImage(){
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: self.imageView.image!)
        }, completionHandler: { (succeed, error) in
            var message = "Wallpaper downloaded to photo library."
            
            if(!succeed){
                message = "Error! Wallpaper not downloaded."
            }
            
            self.showToast(message: message)
        })
    }
    
    func initMediaViewController() {
        mediaViewController = MediaViewController(nibName: "MediaView", bundle: Bundle.main)
        
        let parent = parentViewController!
        parent.addChildViewController(mediaViewController)
        parent.view.addSubview(mediaViewController.view)
        
        mediaViewController.view.frame = parent.view.frame
        mediaViewController.view.layoutIfNeeded()
        
        mediaViewController.imageView.image = imageView.image
        mediaViewController.imageView.setMirrorFromImageView(imageView)
    }
    
    func addHandleFocusToView(_ view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryZoomerManager.handleFocus(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func addHandleDefocusToView(_ view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GalleryZoomerManager.handleDefocus(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func animateScaleUpTransition() {
        let img = mediaViewController.imageView
        let finalFrame = parentViewController!.view.bounds
        let originTransform = img?.transform
        
        UIView.animate(withDuration: self.animationDuration, animations: {
            img?.frame = finalFrame
            let transform = originTransform?.scaledBy(x: self.scaleUpRatio, y: self.scaleUpRatio)
            img?.transform = transform!
            self.mediaViewController.background.alpha = 1
            
            }, completion: { (Bool) in
                UIView.animate(withDuration: self.animationTransformDuration, animations: {
                    img?.transform = originTransform!
                    
                    self.mediaViewController.scrollView.translatesAutoresizingMaskIntoConstraints = true
                    let height = UIApplication.shared.windows[0].frame.height
                
                    img?.frame = CGRect(x: 0, y: 0, width: (img?.frame.width)! * 3, height: height + 140)
                    self.mediaViewController.scrollView.contentSize = CGSize(width: (img?.frame.width)!, height: (img?.frame.height)!)
                    self.mediaViewController.scrollView.contentOffset = CGPoint(x: (img?.frame.width)!/3, y: 70)
                    
                    img?.contentMode = UIViewContentMode.scaleAspectFill
                    
                    img?.translatesAutoresizingMaskIntoConstraints = true
                    
                    self.mediaViewController.scrollView.setNeedsLayout()
                    self.mediaViewController.scrollView.layoutIfNeeded()
                })
        })
    }
    
    func animateScaleDownTransition() {
        let img = mediaViewController.imageView
        let originTransform = imageView.transform
        
        UIView.animate(withDuration: self.animationDuration, animations: {
            let transform = originTransform.scaledBy(x: self.scaleDownRatio, y: self.scaleDownRatio)
            img?.transform = transform
            self.mediaViewController.background.alpha = 0
            img?.alpha = 0
            
            }, completion: { (value: Bool) in
                UIView.animate(withDuration: self.animationTransformDuration, animations: {
                    img?.transform = originTransform
                    
                    }, completion: {(Bool) in
                        self.imageView.isHidden = false
                        self.mediaViewController.view.removeFromSuperview()
                        self.mediaViewController.removeFromParentViewController()
                        self.mediaViewController = nil
                })
        })
    }
}
