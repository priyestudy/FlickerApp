//
//  Utility.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 19/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit
import Foundation

class AppUtility {
    class func saveImageToDocumentDirectory(imageName:String, image:UIImage) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = UIImageJPEGRepresentation(image, 1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    class func retriveImageWithName(name:String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        
         let data = try? Data(contentsOf: fileURL)
        
        if ((data) != nil) {
            guard let image = UIImage(data: data!) else { return nil}
            return image
        }
        return nil
    }
    
    class func saveImageToCaheWithName(imageName:String, image:UIImage) {
        
    }
}
