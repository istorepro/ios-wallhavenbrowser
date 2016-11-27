//
//  ImageLoader.swift
//  WallhavenBrowser
//
//  Created by Michał Szyszka on 12.10.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import Kanna

class ImageExtractor {
    
    //MARK: Properties
    
    let pageSuffix = "&page="
    let imageXPath = "//img[@id='wallpaper']/"
    let imagePreviewXPath = "//a[@class='preview']/@href"
    
    let srcTag = "@src"
    let imageWidthTag = "@data-wallpaper-width"
    let httpsTag = "https:"
    
    var imageArray = [Photo]()
    
    //MARK: Functions
    
    func getImageUrls(galleryType: GalleryType, page: Int,
                      completion: @escaping ([Photo]) -> Void) {
        let url = galleryType.getDescription() + pageSuffix + String(page)
        
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: url)
            
            if let data = try? String(contentsOf: url!) {
                if let doc = HTML(html: data, encoding: .utf8) {
                    for link in doc.xpath(self.imagePreviewXPath) {
                        self.extractImages(link, images: &self.imageArray)
                        completion(self.imageArray)
                    }
                }
            }
        }
    }
    
    //MARK: Private
    
    private func extractImages(_ url: XMLElement, images: inout [Photo]) {
        if let htmlWithImage = try? String(contentsOf: URL(string: url.text!)!){
            if let docWithImage = HTML(html: htmlWithImage, encoding: .utf8) {
                let imageName = docWithImage.xpath(imageXPath + srcTag)[0]
                let imageWidth =  docWithImage.xpath(imageXPath + imageWidthTag)[0].text!
                    
                images.append(Photo(path: httpsTag + imageName.text!, height: 0, width: Float(imageWidth)!))
            }
        }
    }
}
