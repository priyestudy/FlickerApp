//
//  DownloadManager.swift
//  AirtelDemoApp
//
//  Created by Priye Saurabh on 19/08/18.
//  Copyright © 2018 Priye Saurabh. All rights reserved.
//

import UIKit
import Foundation

class DownloadManager {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "ImageDwonloader"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


class ImageDownloader : Operation {
    var recordObj: Record
    
     init(record : Record) {
        recordObj = record
    }
    
    override func main() {
        if isCancelled {
            return
        }
        guard let url = URL(string: recordObj.url!) else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
       
        if isCancelled {
            return
        }
        if !imageData.isEmpty {
            if  let imageObj = UIImage(data: imageData) {
                recordObj.state = DownloadState.Downloaded
                ImageCacheManager.sharedManager.setImageForKey(imageName: recordObj.localUrlName!, image: imageObj)
            } else {
                recordObj.state = DownloadState.Failed
            }
            
        } else {
            recordObj.state = DownloadState.Failed
        }
    }


}
