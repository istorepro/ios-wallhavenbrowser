//
//  UIImageExtensions.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 26.11.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setMirrorFromImageView(_ imageView: UIImageView) {
        let center = self.superview!.convert(imageView.center, from: imageView.superview)
        self.center = center
        self.transform = imageView.transform
        self.bounds = imageView.bounds
        self.layer.cornerRadius = imageView.layer.cornerRadius
        self.contentMode = imageView.contentMode
    }
}
