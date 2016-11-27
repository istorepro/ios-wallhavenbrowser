//
//  Consts.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 26.11.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
class Consts {
    
    static let baseUrlFormat = "https://alpha.wallhaven.cc/search?categories=111&purity=100&sorting=%@&order=desc"
    
    static let favouritesUrl : String = String(format: Consts.baseUrlFormat, "favorites")
    static let viewsUrl : String = String(format: Consts.baseUrlFormat, "views")
    static let dateUrl : String = String(format: Consts.baseUrlFormat, "date_added")    
}
