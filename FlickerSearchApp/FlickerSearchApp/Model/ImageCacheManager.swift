//
//  ImageCacheManager.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 19/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit
import Foundation


class ImageCacheManager {
    var imageCache = NSCache<NSString, UIImage>()
    static let sharedManager = ImageCacheManager()
    
    func setImageForKey(imageName:String,image:UIImage)  {
        let imageN = imageName as NSString
        imageCache.setObject(image, forKey: imageN)
        AppUtility.saveImageToDocumentDirectory(imageName: imageName, image: image)
    }
    
    func imageForIdentifier(identifier:String) -> UIImage? {
        let iden = identifier as NSString
        var image = imageCache.object(forKey: iden)
        if image == nil {
            image = AppUtility.retriveImageWithName(name: identifier)
            if (image != nil) {
                setImageForKey(imageName: identifier, image: image!)
            }
        }
        return image
    }

}
