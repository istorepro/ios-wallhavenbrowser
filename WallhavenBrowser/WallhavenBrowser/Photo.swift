//
//  Photo.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
class Photo {
    
    //MARK: Properties
    
    var path: String
    var height: Float
    var width: Float
    var firstTimeShown: Bool
    var type: PhotoType
    
    //MARK: Inits
    
    init(path: String, height: Float, width: Float,
         type: PhotoType = .Undefined, firstTimeShown: Bool = true) {
        self.path = path
        self.height = height
        self.width = width
        self.firstTimeShown = firstTimeShown
        self.type = type
    }
}
