//
//  GalleryType.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 26.11.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation

enum GalleryType : Int {
    case Favourites, Views, Date
    func getDescription() -> String {
        switch self {
        case .Favourites:
            return Consts.favouritesUrl
        case .Views:
            return Consts.viewsUrl
        case .Date:
            return Consts.dateUrl
        }
    }
}
